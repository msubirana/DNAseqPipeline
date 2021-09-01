#' Mutect2
#' @description
#' Paired tumor-contral somatic calling
#'
#' @param ctrl_bam Control BAM file to use in the analysis
#' @param tumor_bam Tumor BAM file to use in the analysis
#' @param ref Reference fasta genome.
#' @param gnomad GnomAD VCF
#' @param out_pon_path PoN output path (it will create a vcf with the sm name as a name file)
#' @param gatk4 Gatk4 path
#' @param samtools Samtools path
#' @param cores Number of cores to use.
#' @examples
#' \dontrun{}
#' @export
#TODO examples
mutect2 <- function(ctrl_bam,
                                        tumor_bam,
                                        ref='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa',
                                        gnomad='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/af-only-gnomad.hg38.vcf.gz',
                                        out_pon_path,
                                        cores,
                                        gatk4='gatk',
                                        samtools='samtools'){

    ctrl_bam_name <- system(paste(samtools, 'view -H', ctrl_bam),intern = TRUE)
    ctrl_bam_name <- ctrl_bam_name[grep('^@RG', ctrl_bam_name)]
    ctrl_bam_name <- unlist(strsplit(ctrl_bam_name, 'SM:'))[2]

    out_name <- gsub('_BL.bam', '', basename(ctrl_bam))
    out_mutect2 <- file.path(out_pon_path, paste0(out_name, '.vcf.gz'))

    message(paste(
      paste0('\n[', Sys.time(), ']'),
      'Starting mutect2 using:\n',
      '> Ctrl BAM file:\n', ctrl_bam, '\n',
      '> Tumor BAM file:\n', tumor_bam, '\n',
      '> Reference genome:', ref, '\n',
      '> Output vcf:', out_pon, '\n'))

    system(paste(gatk4, '--java-options', paste0('"-XX:ParallelGCThreads=',cores*2,'"'),
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

