% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/germlineStrelka2Manta.R,
%   R/somaticStrelka2Manta.R
\name{strelka2}
\alias{strelka2}
\title{strelka2}
\usage{
strelka2(
  tumor_bam,
  ctrl_bam,
  ref,
  out_dir_strelka2,
  cores,
  conf_strelka2 = "configureStrelkaSomaticWorkflow.py",
  indel_candidates,
  call_regions = "/gpfs42/projects/lab_lpasquali/shared_data/ref/callRegions.bed.gz"
)

strelka2(
  tumor_bam,
  ctrl_bam,
  ref,
  out_dir_strelka2,
  cores,
  conf_strelka2 = "configureStrelkaSomaticWorkflow.py",
  indel_candidates,
  call_regions = "/gpfs42/projects/lab_lpasquali/shared_data/ref/callRegions.bed.gz"
)
}
\arguments{
\item{ref}{Reference fasta genome. By default '/gpfs42/projects/lab_lpasquali/shared_data/marc/ref/hg38/hg38.fa'}

\item{out_dir_strelka2}{Path where the output of the Strelka2 analysis will be saved.}

\item{cores}{Number of cores to use.}

\item{conf_strelka2}{Strelka2 'configureStrelkaGermlineWorkflow.py' path. By default 'configureStrelkaGermlineWorkflow.py'.}

\item{indel_candidates}{'candidateSmallIndels.vcf.gz' file from Manta calling. It is a recommended best practice to provide indel candidates from the Manta SV and indel caller.}

\item{call_regions}{Manta calls the entire genome by default, however variant calling may be restricted to an arbitrary subset of
the genome by providing a region file in BED format with the --callRegions configuration option. The BED file must be bgzip-compressed
and tabix-indexed, and only one such BED file may be specified. When specified, all VCF output is restricted to the provided call regions only,
however statistics derived from the input data}
}
\description{
SVs calling of paired tumor-normal wgs using strelka2

SVs calling of paired tumor-normal wgs using strelka2
}
\examples{
\dontrun{}
\dontrun{}
}
