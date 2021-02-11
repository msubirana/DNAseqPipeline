#load package
library('DNAseqPipeline')
#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables
bam <- args[1]
ref <- args[2]
out_dir_manta <- args[3]
out_dir_strelka <- args[4]
cores <- parallel::detectCores()/2


#realign BAMs using DNAseqPipeline::realignBwa
germlineStrelka2Manta(bam,
                      ref=ref,
                      out_dir=out_dir,
                      cores=cores,
                      out_dir_manta=out_dir_manta,
                      out_dir_strelka2=out_dir_strelka2)
