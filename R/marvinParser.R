#' marvinParser
#'
#' Parser for Marvin cluster
#' Using this parser is possible to send jobs from host to Marvin cluster through ssh
#' It is necessary generate a public and private key pair for an automatic scp
#' @param cores Cores to use
#' @param job_name Name of the job
#' @param partition partition where to run the script. By default 'partition'.
#' @param script Script to run
#' @param memory Amount of RAM used per cpu. By default '8G'.
#' @param email Email where to send notifications. By default 'clusterigtpmsubirana@gmail.com'
#' @param modules List of modules to load. Check the once that you need using module av command in Marvin.
#' @param tmp_sh File where to save the sh script in the host.
#' @param stdout File where standard output output go. Standard output contains all the messages that your job
#' has sent to the standard output messages, i.e. anything you see written.
#' @param stderr File where standard error output go. Standard error contains all the messages that your job has
#' sent to the error channel, i.e. “command not found”, “no such file or directory”…
#' @param nodes Number of nodes
#' @examples
#' \dontrun{
#' bam <- '/gpfs42/projects/lab_lpasquali/shared_data/marc/epimutations/raw/wgs/hg37/toDo/10759.bam'
#' sample <- basename(gsub('.bam','',bam))
#' job_name <- paste0(sample, '_realignBwa')
#' script <- paste('Rscript /gpfs42/projects/lab_lpasquali/shared_data/marc/repos/DNAseqPipeline/tmp/realignBwaParser.R',
#'                 bam,
#'                 ref,
#'                 out_dir,
#'                 threads)
#'
#' email <- 'clusterigtpmsubirana@gmail.com'
#' tmp_sh <- file.path('/home/msubirana', paste0(job_name,'.sh'))
#' memory <- '32G'
#' #' stdout <- file.path(out_dir, job_name)
#' stderr <- file.path(out_dir, job_name)
#'
#' marvinParser(job_name=job_name,
#'              cores=cores,
#'              modules=modules,
#'              script=script,
#'              tmp_sh=tmp_sh,
#'              memory=memory,
#'              stdout=stdout,
#'              stderr=stderr)
#' }
#'
#' @return A job to Marvin cluster and the ib batch job as a message.
#' @export
marvinParser <- function(job_name,
                         cores=1,
                         partition='normal',
                         memory='8G',
                         email='clusterigtpmsubirana@gmail.com',
                         modules=NULL,
                         nodes=1,
                         script,
                         tmp_sh,
                         stdout,
                         stderr){

  #TODO which partitions exist?
  # solve problem with host-marvin connection
  # define tmp file for running in SGE
  if (!is.null(modules)){
    load_modules <- paste('module load', modules, collapse = '\n')}

  cmd <- paste0('#!/bin/bash\n',
                '#SBATCH --exclude=mr-03-[01-26],mr-03-28,mr-04-00',
                '# Job name identification\n',
                '#SBATCH -J ', job_name, '\n',
                '# set the partition where the job will run\n',
                '#SBATCH --partition=', partition,'\n',
                '# Number of nodes\n',
                '#SBATCH --nodes=', nodes, '\n',
                '# Number of cores\n',
                '#SBATCH --cpus-per-task=', cores, '\n',
                '# Send an email if the job\n',
                '#SBATCH --mail-user=', email, '\n',
                '#+ starts / ends / fails\n',
                '#SBATCH --mail-type=BEGIN,END,FAIL\n',
                '# memory per CPU\n',
                '#SBATCH --mem-per-cpu=', memory, '\n',
                '# Standard output\n',
                '#SBATCH -o ', paste0(stdout, '.out'), '\n',
                '# Standard error\n',
                '#SBATCH -e ', paste0(stderr, '.err'), '\n',
                '# load modules\n',
                load_modules,
                '\n# run application\n',
                script)
  write(cmd,
        file=tmp_sh)

  system(paste('scp',
               tmp_sh,
               'msubirana@marvin.s.upf.edu:/gpfs42/projects/lab_lpasquali/shared_data/marc/tmp/marvinParserScripts'))

  tmp_sh_marvin <- file.path('/gpfs42/projects/lab_lpasquali/shared_data/marc/tmp/marvinParserScripts', basename(tmp_sh))

  session <- ssh::ssh_connect('msubirana@marvin.s.upf.edu')

  env <- "for i in /etc/profile.d/*.sh; do if [ $i != '/etc/profile.d/z_motd_info.sh' ]; then . $i; fi done;"

  stdout <- ssh::ssh_exec_wait(session, command = c(
    env,
    paste('sbatch', tmp_sh_marvin)))

  message(stdout)

}
