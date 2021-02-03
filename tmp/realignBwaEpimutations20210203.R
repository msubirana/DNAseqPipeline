devtools::load_all('/homes/users/msubirana/lab_lpasquali/shared_data/marc/repos/DNAseqPipeline')
ref <- '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa'
bam_path <- '/homes/users/msubirana/lab_lpasquali/shared_data/marc/epimutations/raw/wgs/hg37/toDo'

bams <- list.files(bam_path,
                   pattern = ".bam$",
                   full.names = T)

out_dir <- '/homes/users/msubirana/lab_lpasquali/shared_data/marc/epimutations/raw/wgs/hg38'
threads <- 8

for(bam in bams){

    realignBwa(bam=bam,
             ref=ref,
             out_dir=out_dir,
             threads=threads)
  
}

