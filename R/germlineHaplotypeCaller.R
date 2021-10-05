#' haplotypecaller
#' @description
#' Germline SNVs and INDELs calling using haplotypecaller
#'
#' @param bam BAM file to use in the analysis
#' @param ref Reference fasta genome. By default '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa'
#' @param out_dir_haplotypecaller Path where the output of the haplotypecaller analysis will be saved.
#' @param cores Number of cores to use.
#' @examples
#' \dontrun{}
#' @export
haplotypecaller <- function(bam,
                  ref,
                  out_dir_haplotypecaller,
                  cores){

  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting haplotypecaller using:\n',
    '> BAM file:\n', bam, '\n',
    '> Reference genome:', ref, '\n',
    '> Output directory:', out_dir_haplotypecaller, '\n',
    '> Number of cores:', cores, '\n'))

  sample <- basename(sub('.bam' ,'' , bam))

  # configuration
  out_haplotypecaller <- file.path(out_dir_haplotypecaller, sample, 'vcf.gz')

  # create output directory if not exist
  dir.create(out_dir_haplotypecaller, showWarnings = FALSE)

  system(paste('gatk', paste0('-java-options "-XX:ParallelGCThreads=', cores,'"'),
               'HaplotypeCaller',
               '-R', ref,
               '-I', bam,
               '-O', out_haplotypecaller,
               '-ERC GVCF'))


  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Finished', bam))
}
