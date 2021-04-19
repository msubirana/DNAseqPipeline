#load package
devtools::load_all('/gpfs42/projects/lab_lpasquali/shared_data/marc/repos/DNAseqPipeline')

#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables
file <- args[1]
out_dir <- args[2]
threads <- parallel::detectCores()


#realign BAMs using DNAseqPipeline::realignBwa
fastqc(file=file,
       out_dir=out_dir,
       threads=threads)
