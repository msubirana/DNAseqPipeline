devtools::load_all('/home/msubirana/Documents/phd/repos/DNAseqPipeline')
ref <- '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa'
bam_path <- '/homes/users/msubirana/lab_lpasquali/shared_data/marc/epimutations/raw/wgs/hg37/toDo'
bams <- list.files(bam_path,
                   pattern = ".bam$",
                   full.names = T)
out_dir <- '/homes/users/msubirana/lab_lpasquali/shared_data/marc/epimutations/raw/wgs/hg38'
threads <- 16
cores=threads/2
modules <- c('BWA/0.7.15',
             'msamblaster/0.1.24-foss-2016b',
             'SAMtools/1.11-GCC-9.3.0',
             'R/4.0.0-foss-2020a')

tmp_sh <- '/home/msubirana/tmp.sh'

for(bam in bams){

  sample <- gsub('.bam','',bam)
  job_name = paste0(sample_name, '_realignBwa')
  script = paste('Rscript /gpfs42/projects/lab_lpasquali/shared_data/marc/repos/DNAseqPipeline/R/realignBwaParser.R',
                 bam,
                 ref,
                 out_dir,threads)
  email = 'clusterigtpmsubirana@gmail.com'

  marvinParser(job_name=job_name,
               cores=cores,
               modules=modules,
               script=script,
               tmp_sh=tmp_sh)



}

