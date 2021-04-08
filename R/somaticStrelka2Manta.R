#' somaticStrelka2Manta
#' @description
#' Somatic SNVs and SVs calling using Strelka2 and Manta
#'
#' @param tumor_bam Tumor BAM file to use in the analysis
#' @param ctrl_bam Tumor BAM file to use in the analysis
#' @param ref Reference fasta genome. By default '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa'
#' @param out_dir_manta Path where the output of the Manta analysis will be saved.
#' @param out_dir_strelka2 Path where the output of the Strelka2 analysis will be saved.
#' @param cores Number of cores to use.
#' @param conf_manta Manta 'configManta.py' path. By default 'configManta.py'
#' @param call_regions Manta calls the entire genome by default, however variant calling may be restricted to an arbitrary subset of
#' the genome by providing a region file in BED format with the --callRegions configuration option. The BED file must be bgzip-compressed
#' and tabix-indexed, and only one such BED file may be specified. When specified, all VCF output is restricted to the provided call regions only,
#' however statistics derived from the input data
#' @param conf_strelka2 Strelka2 'configureStrelkaSomaticWorkflow.py' path. By default 'configureStrelkaSomaticWorkflow.py'.
#' @examples
#' \dontrun{}
#' @export
#TODO examples
somaticStrelka2Manta <- function(tumor_bam,
                                  ctrl_bam,
                                  ref='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa',
                                  out_dir_manta,
                                  out_dir_strelka2,
                                  cores,
                                  conf_manta='configManta.py',
                                  call_regions='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/callRegions.bed.gz',
                                  conf_strelka2='configureStrelkaSomaticWorkflow.py'){
  
  
  manta(tumor_bam=tumor_bam,
        ctrl_bam=ctrl_bam,
        ref=ref,
        out_dir_manta=out_dir_manta,
        cores=cores,
        conf_manta=conf_manta,
        call_regions=call_regions)
  
  sample <- basename(sub('_TI.bam' ,'' , tumor_bam))
  out_manta <- file.path(out_dir_manta, sample)
  indel_candidates <- file.path(out_manta, 'results/variants/candidateSmallIndels.vcf.gz')
  
  strelka2(tumor_bam,
           ctrl_bam,
           ref=ref,
           out_dir_strelka2=out_dir_strelka2,
           cores=cores,
           conf_strelka2=conf_strelka2,
           call_regions=call_regions,
           indel_candidates=indel_candidates)
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
manta <- function(tumor_bam,
                  ctrl_bam,
                  ref='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa',
                  out_dir_manta,
                  cores,
                  conf_manta='configManta.py',
                  call_regions='/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/callRegions.bed.gz'){
  
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting manta using:\n',
    '> Tumor BAM file:\n', tumor_bam, '\n',
    '> Ctrl BAM file:\n', ctrl_bam, '\n',
    '> Reference genome:', ref, '\n',
    '> Output directory:', out_dir_manta, '\n',
    '> Number of cores:', cores, '\n'))
  
  sample <- basename(sub('_TI.bam' ,'' , tumor_bam))
  
  # configuration
  out_manta <- file.path(out_dir_manta, sample)
  
  # create output directory if not exist
  dir.create(out_manta, showWarnings = FALSE)
  
  system(paste(conf_manta,
               "--normalBam", ctrl_bam,
               "--tumorBam", tumor_bam,
               "--referenceFasta", ref,
               "--runDir", out_manta))
  
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
strelka2 <- function(tumor_bam,
                     ctrl_bam,
                     ref,
                     out_dir_strelka2,
                     cores,
                     conf_strelka2='configureStrelkaSomaticWorkflow.py',
                     indel_candidates,
                     call_regions='/gpfs42/projects/lab_lpasquali/shared_data/ref/callRegions.bed.gz'){
  
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting strelka2 using:\n',
    '> Tumor BAM file:\n', tumor_bam, '\n',
    '> Ctrl BAM file:\n', ctrl_bam, '\n',
    '> Reference genome:', ref, '\n',
    '> Output directory:', out_dir_strelka2, '\n',
    '> Number of cores:', cores, '\n',
    '> Indel candidates:', indel_candidates, '\n'))
  
  sample <- basename(sub('_TI.bam' ,'' , tumor_bam))
  
  # configuration
  out_strelka2 <- file.path(out_dir_strelka2, sample)
  # create output directory if not exist
  dir.create(out_strelka2, showWarnings = FALSE)
  
  system(paste(conf_strelka2,
               "--normalBam", ctrl_bam,
               "--tumorBam", tumor_bam,
               "--referenceFasta", ref,
               "--runDir", out_strelka2,
               '--indelCandidates', indel_candidates,
               '--callRegions', call_regions))
  
  # execution of job in the defined cores
  run_strelka2 <- file.path(out_strelka2, 'runWorkflow.py')
  
  system(paste(run_strelka2,
               '-m local',
               '-j', cores))
  
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Finished', bam))
}
