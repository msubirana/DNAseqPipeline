#load package
devtools::load_all('/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/marc/repos/DNAseqPipeline')

#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables
bam <- args[1]
ref <- args[2]
out_dir_haplotypecaller <- args[3]
cores <- parallel::detectCores()/2


#calling varianyts using DNAseqPipeline::germlineStrelka2Manta
haplotypecaller(bam,
                      ref=ref,
                      cores=cores,
                      out_dir_manta=out_dir_manta,
                      out_dir_strelka2=out_dir_strelka2,
                      call_regions=call_regions)
