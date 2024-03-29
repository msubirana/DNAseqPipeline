#' Mutect2
#' @description
#' Paired tumor-contral somatic calling
#'
#' @param ctrl_bam Control BAM file to use in the analysis
#' @param tumor_bam Tumor BAM file to use in the analysis
#' @param ref Reference fasta genome.
#' @param gnomad GnomAD VCF
#' @param out_mutect2_path Output path (it will create a vcf with the sm name as a name file)
#' @param gatk4 Gatk4 path
#' @param samtools Samtools path
#' @param ctrl_bam_name Sample name of the ctrl
#' @param cores Number of cores to use.
#' @examples
#' \dontrun{}
#' @export
#TODO examples
mutect2 <- function(ctrl_bam,
                                        tumor_bam,
                                        ctrl_bam_name,
                                        ref='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa',
                                        gnomad='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/af-only-gnomad.hg38.vcf.gz',
                                        out_mutect2_path,
                                        cores,
                                        gatk4='gatk',
                                        samtools='samtools'){

    out_name <- gsub('_BL.bam', '', basename(ctrl_bam))
    out_mutect2 <- file.path(out_mutect2_path, paste0(out_name, '.vcf'))

    message(paste(
      paste0('\n[', Sys.time(), ']'),
      'Starting mutect2 using:\n',
      '> Ctrl BAM file:\n', ctrl_bam, '\n',
      '> Tumor BAM file:\n', tumor_bam, '\n',
      '> Reference genome:', ref, '\n',
      '> Output vcf:', out_mutect2_path, '\n'))

    system(paste(gatk4, '--java-options', paste0('"-XX:ParallelGCThreads=',as.numeric(cores)*2,'"'),
                 'Mutect2',
                 '-R', ref,
                 '-I', tumor_bam,
                 '-I', ctrl_bam,
                 '-normal', ctrl_bam_name,
                 '--germline-resource', gnomad,
                 '-O', out_mutect2))

    message(paste(
      paste0('\n[', Sys.time(), ']'),
      'Finished', ctrl_bam_name))
}

