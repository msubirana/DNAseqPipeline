#' marvinParser
#'
#' Parser for Marvin cluster
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
#' @examples
#' \dontrun{}
#' @export
marvinParser <- function(job_name,
                         cores=1,
                         partition='normal',
                         memory='8G',
                         email='clusterigtpmsubirana@gmail.com',
                         modules=NULL,
                         script,
                         tmp_sh,
                         stdout,
                         stderr){
  
  #TODO which partitions exist?
  #TODO log path
  # define tmp file for running in SGE
  if (!is.null(modules)){
    load_modules <- paste('module load', modules, collapse = '\n')}
  
  cmd <- paste0('#!/bin/bash\n', 
                '# Job name identification\n',
                '#SBATCH -J ', job_name, '\n',
                '# set the partition where the job will run\n',
                '#SBATCH --partition=', partition,'\n',
                '# Number of cores\n',
                '#SBATCH -n', cores, '\n',
                '# Send an email if the job\n',
                '#SBATCH --mail-user=', email, '\n',
                '#+ starts / ends / fails\n',
                '#SBATCH --mail-type=BEGIN,END,FAIL\n', 
                '# memory per CPU\n',
                '#SBATCH --mem-per-cpu=', memory, '\n',
                '# Standard output',
                '#SBATCH -o ' paste0(stdout, '.out'),
                '# Standard error',
                '#SBATCH -e ', paste0(stderr, '.err'),  
                '#load modules\n',
                load_modules,
                '\n#run application\n',
                script)
  
  write(cmd,
        file=tmp_sh)
  
  system(paste('scp',
               tmp_sh,
               'msubirana@marvin.s.upf.edu:/gpfs42/projects/lab_lpasquali/shared_data/marc/tmp/marvinParserScripts'))
  
  tmp_sh_marvin <- file.path('/gpfs42/projects/lab_lpasquali/shared_data/marc/tmp/marvinParserScripts', basename(tmp_sh))
  
  ssh_connection <- ssh::ssh_connect('msubirana@marvin.s.upf.edu')
  ssh::ssh_exec_internal(ssh_connection, command = paste('sbatch', tmp_sh_marvin))
  
}




