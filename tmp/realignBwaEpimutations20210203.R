#creat ssh sesison
ssh_connection <- ssh::ssh_connect('msubirana@marvin.s.upf.edu')

#load packages
devtools::load_all('/home/msubirana/Documents/phd/repos/DNAseqPipeline')

#define variables
ref <- '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa'
bam_path <- '/gpfs42/projects/lab_lpasquali/shared_data/marc/epimutations/raw/wgs/hg37/toDo'
ls_output <- ssh::ssh_exec_internal(ssh_connection, command = paste('ls', bam_path))
bams_tmp <- unlist(strsplit(rawToChar(ls_output$stdout), '\n'))
bams_tmp <- bams_tmp[grepl('.bam$', bams_tmp)]
bams <- file.path(bam_path,bams_tmp)
out_dir <- '/gpfs42/projects/lab_lpasquali/shared_data/marc/epimutations/raw/wgs/hg38'
threads <- 16
cores=threads/2
modules <- c('BWA/0.7.15',
             'samblaster/0.1.24-foss-2016b',
             'SAMtools/1.11-GCC-9.3.0',
             'R/4.0.0-foss-2020a')

for(bam in bams){
  sample <- basename(gsub('.bam','',bam))
  job_name <- paste0(sample, '_realignBwa')
  script <- paste('Rscript /gpfs42/projects/lab_lpasquali/shared_data/marc/repos/DNAseqPipeline/tmp/realignBwaParser.R',
                 bam,
                 ref,
                 out_dir,
                 threads)

  email <- 'clusterigtpmsubirana@gmail.com'
  tmp_sh <- file.path('/home/msubirana', paste0(job_name,'.sh'))
  memory <- '30G'
  marvinParser(job_name=job_name,
               cores=cores,
               modules=modules,
               script=script,
               tmp_sh=tmp_sh,
               memory=memory)

}

