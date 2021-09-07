#load package
devtools::load_all('/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/marc/repos/DNAseqPipeline')

#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables
ctrl_bam <- args[1]
tumor_bam <- args[2]
ctrl_bam_name <- args[3]
out_mutect2_path <- args[4]
cores <- args[5]

#calling varianyts using DNAseqPipeline::somaticStrelka2Manta
mutect2(ctrl_bam=ctrl_bam,
        tumor_bam=tumor_bam,
        ctrl_bam_name=ctrl_bam_name,
        out_mutect2_path=out_mutect2_path,
        cores=cores)
