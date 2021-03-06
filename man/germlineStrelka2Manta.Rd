% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/germlineStrelka2Manta.R
\name{germlineStrelka2Manta}
\alias{germlineStrelka2Manta}
\title{germlineStrelka2Manta}
\usage{
germlineStrelka2Manta(
  bam,
 
    ref = "/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa",
  out_dir_manta,
  out_dir_strelka2,
  cores,
  conf_manta = "configManta.py",
 
    call_regions = "/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/ref/callRegions.bed.gz",
  conf_strelka2 = "configureStrelkaGermlineWorkflow.py"
)
}
\arguments{
\item{bam}{BAM file to use in the analysis}

\item{ref}{Reference fasta genome. By default '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa'}

\item{out_dir_manta}{Path where the output of the Manta analysis will be saved.}

\item{out_dir_strelka2}{Path where the output of the Strelka2 analysis will be saved.}

\item{cores}{Number of cores to use.}

\item{conf_manta}{Manta 'configManta.py' path. By default 'configManta.py'}

\item{call_regions}{Manta calls the entire genome by default, however variant calling may be restricted to an arbitrary subset of
the genome by providing a region file in BED format with the --callRegions configuration option. The BED file must be bgzip-compressed
and tabix-indexed, and only one such BED file may be specified. When specified, all VCF output is restricted to the provided call regions only,
however statistics derived from the input data}

\item{conf_strelka2}{Strelka2 'configureStrelkaGermlineWorkflow.py' path. By default 'configureStrelkaGermlineWorkflow.py'.}
}
\description{
Germline SNVs and SVs calling using Strelka2 and Manta
}
\examples{
\dontrun{}
}
