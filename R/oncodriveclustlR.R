#' oncodriveclustlParser
#' @description
#' OncodriveCLUSTL parser

#' @param inputFile File containing mutations (required)
#' @param regionFile GZIP compressed file with the genomic regions to analyze (required)
#' @param outputDirectory Output directory to be created (required)
#' @param genome Genome to use. Default is hg38
#' @param elementMutations Cutoff of element mutations. Default is 2
#' @param clusterMutations Cutoff of cluster mutations. Default is 2
#' @param smoothWindow Smoothing window. Default is 11
#' @param clusterWindow Cluster window. Default is 11
#' @param simulationWindow Simulation window. Default is 31
#' @param kmer K-mer nucleotide context (3 or 5) to calculate mutational probabilities. Default is 5
#' @param signatureCalculation calculation of mutational probabilities as mutation frequencies ('frequencies') or k-mer mutation counts normalized by k-mer region counts ('region_normalized'). Default is region_normalized
#' @param cores Number of cores to use in the computation. By default 1

oncodriveclustlR <- function(inputFile,
                                  regionFile,
                                  outputDirectory,
                                  genome='hg38',
                                  elementMutations=2,
                                  clusterMutations=2,
                                  smoothWindow=11,
                                  clusterWindow=11,
                                  simulationWindow=31,
                                  kmer=5,
                                  signatureCalculation='region_normalized',
                                  cores=1){
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Starting OncodriveCLUSTL'))
  
  system('source activate oncodriveclustl')
  system(paste('oncodriveclustl',
               '-i', inputFile,
               '-r', regionFile,
               '-o', outputDirectory,
               '--qqplot',
               '--genome', genome,
               '-c', cores,
               '-kmer', kmer,
               '--signature-calculation', signatureCalculation,
               '-emut', elementMutations,
               '-cmut', clusterMutations,
               '-sw', smoothWindow,
               '-cw', clusterWindow,
               '-simw', simulationWindow))
               
               
  
  message(paste(
    paste0('\n[', Sys.time(), ']'),
    'Finished OncodriveCLUSTL'))
  
}
          

