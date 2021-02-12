#' germlineStrelka2Manta
#' @description
#' Germline SNVs and SVs calling using Strelka2 and Manta
#'
#' @param bam BAM file to use in the analysis
#' @param ref Reference fasta genome. By default '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa'
#' @param out_dir_manta Path where the output of the Manta analysis will be saved.
#' @param out_dir_strelka2 Path where the output of the Strelka2 analysis will be saved.
#' @param cores Number of cores to use.
#' @param conf_manta Manta 'configManta.py' path. By default 'configManta.py'
#' @param conf_strelka2 Strelka2 'configureStrelkaGermlineWorkflow.py' path. By default 'configureStrelkaGermlineWorkflow.py'.
#' @param call_regions Bed file of all the chromosomes that should be included in the analysis.
#' For instance, the following bed file could be provided to exclude all decoys and small contigs. File should be bgzip and tabix.
#' By default '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/GRCh38_exclude_decoys_small_contigs.bed'
#' @examples
#' \dontrun{}
#' @export
germlineStrelka2Manta <- function(bam,
                                  ref='/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa',
                                  out_dir_manta,
                                  out_dir_strelka2,
                                  cores,
                                  conf_manta='configManta.py',
                                  conf_strelka2='configureStrelkaGermlineWorkflow.py'){
  #call_regions='/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/GRCh38_exclude_decoys_small_contigs.bed.gz'


  manta(bam=bam,
        ref=ref,
        out_dir_manta=out_dir_manta,
        cores=cores,
        conf_manta=conf_manta)

  #call_regions=call_regions

  sample <- basename(sub('.bam' ,'' , bam))
  out_manta <- file.path(out_dir_manta, sample)
  indel_candidates <- file.path(out_manta, '/results/variants/candidateSmallIndels.vcf.gz')

  strelka2(bam=bam,
           ref=ref,
           out_dir_strelka2=out_dir_strelka2,
           cores=cores,
           conf_strelka2=conf_strelka2,
           indel_candidates=indel_candidates)

  #           call_regions=call_regions,

}

#' manta
#'
#' @description
#' SVs calling of paired tumor-normal wgs using manta
#'
#' @inheritParams germlineStrelka2Manta
#'
#' @examples
#' \dontrun{}
#' @export
manta <- function(bam,
                  ref,
                  out_dir_manta,
                  cores,
                  conf_manta='configManta.py'){

  #call_regions='/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/GRCh38_exclude_decoys_small_contigs.bed.gz'
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting manta using:\n',
    '> BAM file:\n', bam, '\n',
    '> Reference genome:', ref, '\n',
    '> Output directory:', out_dir_manta, '\n',
    '> Number of cores:', cores, '\n'))

  sample <- basename(sub('.bam' ,'' , bam))

  # configuration
  out_manta <- file.path(out_dir_manta, sample)

  # create output directory if not exist
  dir.create(out_manta, showWarnings = FALSE)

  system(paste(conf_manta,
               '--bam', bam,
               '--referenceFasta', ref,
               '--runDir', out_manta))
  #--callRegions', call_regions

  # execution of job in the defined cores
  run_manta <- file.path(out_manta, 'runWorkflow.py')

  system(paste(run_manta,
               '-m local',
               '-j', cores))

  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Finished', bam))
}
#' strelka2
#'
#' @description
#' SVs calling of paired tumor-normal wgs using strelka2
#'
#' @inheritParams germlineStrelka2Manta
#' @param indel_candidates 'candidateSmallIndels.vcf.gz' file from Manta calling. It is a recommended best practice to provide indel candidates from the Manta SV and indel caller.
#' @examples
#' \dontrun{}
#' @export
strelka2 <- function(bam,
                  ref,
                  out_dir_strelka2,
                  cores,
                  conf_strelka2='configureStrelkaGermlineWorkflow.py',
                  indel_candidates){

  #call_regions='/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/GRCh38_exclude_decoys_small_contigs.bed.gz'
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting strelka2 using:\n',
    '> BAM file:\n', bam, '\n',
    '> Reference genome:', ref, '\n',
    '> Output directory:', out_dir_strelka2, '\n',
    '> Number of cores:', cores, '\n',
    '> Indel candidates:', indel_candidates, '\n'))

  sample <- basename(sub('.bam' ,'' , bam))

  # configuration
  out_strelka2 <- file.path(out_dir_strelka2, sample)
  # create output directory if not exist
  dir.create(out_strelka2, showWarnings = FALSE)

  system(paste(conf_strelka2,
               '--bam', bam,
               '--referenceFasta', ref,
               '--runDir', out_strelka2,
               '--indelCandidates', indel_candidates))

  #'--callRegions', call_regions

  # execution of job in the defined cores
  run_strelka2 <- file.path(out_strelka2, 'runWorkflow.py')

  system(paste(run_strelka2,
               '-m local',
               '-j', cores))

  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Finished', bam))
}
