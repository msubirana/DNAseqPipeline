#load package
devtools::load_all('/gpfs42/projects/lab_lpasquali/shared_data/marc/repos/DNAseqPipeline')

#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables
tumor_bam <- args[1]
ctrl_bam <- args[2]
ref <- args[3]
out_dir_manta <- args[4]
out_dir_strelka2 <- args[5]
call_regions <- args[6]
cores <- parallel::detectCores()/2

#calling varianyts using DNAseqPipeline::somaticStrelka2Manta
somaticStrelka2Manta(tumor_bam=tumor_bam,
                                 ctrl_bam=ctrl_bam,
                                 out_dir_manta=out_dir_manta,
                                 out_dir_strelka2=out_dir_strelka2,
                                 cores=cores,
                                 call_regions=call_regions)
