#load package
devtools::load_all('/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/marc/repos/DNAseqPipeline')

#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables
fq1 <- args[1]
fq2 <- args[2]
ref <- args[3]
out_dir <- args[4]
threads <- parallel::detectCores()


#realign BAMs using DNAseqPipeline::realignBwa
pealignBwa(fq1=fq1,
           fq2=fq2,
           ref=ref,
           out_dir=out_dir,
           threads=threads)
