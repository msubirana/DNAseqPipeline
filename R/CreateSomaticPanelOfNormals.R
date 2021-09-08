#' CreateSomaticPanelOfNormals
#' @description
#' Make a panel of normals for use with Mutect2
#'
#' @param ctrl_bam Tumor BAM file to use in the analysis
#' @param ref Reference fasta genome. By default '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa'
#' @param gnomad GnomAD VCF
#' @param out_pon_path PoN output path (it will create a vcf with the sm name as a name file)
#' @param gatk4 Gatk4 path
#' @param samtools Samtools path
#' @param cores Number of cores to use.
#' @param ctrl_bam_name Sample name of the ctrl
#' @examples
#' \dontrun{}
#' @export
#TODO examples
CreateSomaticPanelOfNormals <- function(ctrl_bam,
                                        ctrl_bam_name,
                                 ref='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa',
                                 gnomad='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/af-only-gnomad.hg38.vcf.gz',
                                 out_pon_path,
                                 cores,
                                 gatk4='gatk',
                                 samtools='samtools'){

  out_pon <- file.path(out_pon_path, paste0(ctrl_bam_name, '.vcf.gz'))

  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting CreateSomaticPanelOfNormals using:\n',
    '> Ctrl BAM file:\n', ctrl_bam, '\n',
    '> Reference genome:', ref, '\n',
    '> Output vcf:', out_pon, '\n'))

  system(paste(gatk4, '--java-options', paste0('"-XX:ParallelGCThreads=',as.numeric(cores)*2,'"'),
               'Mutect2',
               '-R', ref,
               '-I', ctrl_bam,
               '-tumor', ctrl_bam_name,
               '--germline-resource', gnomad,
               '-O', out_pon))

  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Finished', ctrl_bam))
}

