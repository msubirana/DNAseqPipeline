#load package
devtools::load_all('/gpfs42/projects/lab_lpasquali/shared_data/marc/repos/DNAseqPipeline')

#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables
bam <- args[1]
ref <- args[2]
out_dir_manta <- args[3]
out_dir_strelka2 <- args[4]
call_regions <- args[5]
cores <- parallel::detectCores()/2


#calling varianyts using DNAseqPipeline::germlineStrelka2Manta
germlineStrelka2Manta(bam,
                      ref=ref,
                      cores=cores,
                      out_dir_manta=out_dir_manta,
                      out_dir_strelka2=out_dir_strelka2,
                      call_regions=call_regions)
