#load package
devtools::load_all('/gpfs42/projects/lab_lpasquali/shared_data/marc/repos/DNAseqPipeline')

#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables
ctrl_bam <- args[1]
out_pon_path <- args[2]
cores <- args[3]

#calling varianyts using DNAseqPipeline::somaticStrelka2Manta
CreateSomaticPanelOfNormals(ctrl_bam=ctrl_bam,
                            out_pon_path=out_pon_path,
                            cores=cores)
