#' realignBwa
#'
#' Convert paired-end bam files to fastqs and then realign with bwa mem   
#'
#' @param bam Paired-end BAM file to realign
#' @param threads Number of threads to use in the analysis.
#' @param ref Reference genome (ref.fa) to use for the alignment. 
#' @param platform Platforme used in the sequecing process. By default 'ILLUMINA'.
#' @param bwa Path to the executable bwa. By default 'bwa'.
#' @param samtools Path to the executable bwa. By default 'samtools'.
#' @param samblaster Path to the executable bwa. By default 'samblaster'.
#' @examples
#' \dontrun{
#' bam <- '/media/msubirana/insulinomas/epimutations/processed/hg37/bam/longranges/wgs/sub_10759.bam'
#' ref <- '/home/msubirana/Documents/phd/refgen/hg38/hg38.fa'
#' out_dir <- '/media/msubirana/insulinomas/epimutations/processed/hg37/bam/longranges/wgs/subset_proves'
#' threads <- 6
#' realignBwa(bam=bam,
#'            ref=ref,
#'            out_dir=out_dir)
#'}
#' @export
realignBwa <- function(bam,
                       ref,
                       out_dir,
                       threads=1,
                       temp=file.path(out_dir,'temp'),
                       platform='ILLUMINA',
                       bwa='bwa',
                       samtools='samtools',
                       samblaster='samblaster'
                       ){
  
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting realignBwa using:\n',
    '> BAM file:\n', bam, '\n',
    '> Reference genome:', ref, '\n',
    '> Output directory:', out_dir, '\n',
    '> Number of threads:', threads, '\n',
    '> Output directory:', out_dir, '\n',
    '> Output directory:', out_dir, '\n'))
    
    
  sample <- basename(sub('.bam' ,'' , bam))
  temp <- file.path(out_dir,'temp')
  dir.create(temp, showWarnings = FALSE)
  system(paste(samtools, 'bam2fq -@', threads, bam, '|',  #bam to fq
        bwa, 'mem -p -t', threads, # align bam
        paste0("-R \"@RG\\tID:",sample,"\\tPL:",platform,"\\tPU:1\\tSM:", sample,"\""),
        ref,' - |',
        samblaster, '|', #markduplicates
        samtools, 'sort -@', threads, '-T', temp, '-o', file.path(out_dir, paste0(sample, '_out_sorted_markdup.bam')), ";",
        samtools, 'index -@', threads, file.path(out_dir, paste0(sample, '_out_sorted_markdup.bam'))))
  
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Finished', bam))

  }

