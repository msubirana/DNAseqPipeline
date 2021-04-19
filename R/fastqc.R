#' fastqc
#'
#' Fastqc analysis of a folder with fq or bams
#'
#' @param file Bam or fastq to fastqc
#' @param out_dir Fatqc out directory
#' @param threads Number of threads to use in the analysis.
#' @param fastqc Executable fastqc
#' @export
fastqc <- function(file,
                   out_dir,
                   threads=1,
                   fastqc='fastqc'){
  
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting fastqc using:\n',
    '> File:\n', file, '\n',
    '> Output directory:', out_dir, '\n',
    '> Number of threads:', threads, '\n'))
  

  system(paste(fastqc, file, '-o', out_dir, '-t', threads))
   
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Finished', file))
  
}

