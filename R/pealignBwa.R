#' pealignBwa
#'
#' Align paired-end fq files using bwa mem
#'
#' @param fq1 Fastq R1 file of paired-end data.
#' @param fq2 Fastq R2 file of paired-end data.
#' @param threads Number of threads to use in the analysis.
#' @param ref Reference genome (ref.fa) to use for the alignment.
#' @param platform Platforme used in the sequecing process. By default 'ILLUMINA'.
#' @param bwa Path to the executable bwa. By default 'bwa'.
#' @param samtools Path to the executable bwa. By default 'samtools'.
#' @param samblaster Path to the executable bwa. By default 'samblaster'.
#' @examples
#' \dontrun{
#' fq1 <- '/media/msubirana/insulinomas/epimutations/processed/hg37/bam/longranges/wgs/sub_10759_R1.fa'
#' fq2 <- '/media/msubirana/insulinomas/epimutations/processed/hg37/bam/longranges/wgs/sub_10759_R2.fa'
#' ref <- '/home/msubirana/Documents/phd/refgen/hg38/hg38.fa'
#' out_dir <- '/media/msubirana/insulinomas/epimutations/processed/hg37/bam/longranges/wgs/subset_proves'
#' threads <- 6
#' pealignBwa(fq1=fq1,
#'            fq2=fq2,
#'            ref=ref,
#'            out_dir=out_dir)
#'}
#' @export
pealignBwa <- function(fq1,
                       fq2,
                       ref='/gpfs42/projects/lab_lpasquali/shared_data/ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa',
                       out_dir,
                       threads=1,
                       temp=file.path(out_dir,'temp'),
                       platform='ILLUMINA',
                       bwa='bwa',
                       samtools='samtools',
                       samblaster='samblaster'){
  
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting pealignBwa using:\n',
    '> FastQ R1 file:\n', fq1, '\n',
    '> FastQ R2 file:\n', fq2, '\n',
    '> Reference genome:', ref, '\n',
    '> Output directory:', out_dir, '\n',
    '> Number of threads:', threads, '\n',
    '> Output directory:', out_dir, '\n'))
  
  sample <- basename(gsub("\\..*","",fq1))
  temp <- file.path(out_dir,'temp')
  dir.create(temp, showWarnings = FALSE)

  system(paste(bwa, 'mem -M -t', threads, # align bam
               paste0("-R \"@RG\\tID:",sample,"\\tPL:",platform,"\\tPU:1\\tSM:", sample,"\""),
               ref, fq1, fq2, '|',
               samblaster, '-M |', #markduplicates
               samtools, 'view -Sb -@', threads, '- |',
               samtools, 'sort -@', threads, '-T', temp, '-o', file.path(out_dir, paste0(sample, '.bam')), ";",
               samtools, 'index -@', threads, file.path(out_dir, paste0(sample, '.bam'))))
  
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Finished', bam))
  
}

