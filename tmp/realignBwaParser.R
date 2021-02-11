#load package
devtools::load_all('/gpfs42/projects/lab_lpasquali/shared_data/marc/repos/DNAseqPipeline')

#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables
bam <- args[1]
ref <- args[2]
out_dir <- args[3]
threads <- parallel::detectCores()


#realign BAMs using DNAseqPipeline::realignBwa
realignBwa(bam=bam,
           ref=ref,
           out_dir=out_dir,
           threads=threads)
