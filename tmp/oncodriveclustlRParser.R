#load package
devtools::load_all('/gpfs42/robbyfs/scratch/lab_lpasquali/msubirana/repos/DNAseqPipeline')

#parse arguments
args <- base::commandArgs(trailingOnly = TRUE)

#define variables

inputFile <- args[1]
regionFile <- args[2]
outputDirectory <- args[3]
elementMutations <- args[4]
clusterMutations <- args[5]
smoothWindow <- args[6]
clusterWindow <- args[7]
simulationWindow <- args[8]
kmer <- args[9]
simulationWindow <- args[10]
cores <- parallel::detectCores()/2


#calling varianyts using DNAseqPipeline::oncodriveclustlR
oncodriveclustlR(inputFile=inputFile,
                 regionFile=regionFile,
                 outputDirectory=outputDirectory,
                 elementMutations=elementMutations,
                 clusterMutations=clusterMutations,
                 smoothWindow=smoothWindow,
                 clusterWindow=clusterWindow,
                 simulationWindow=simulationWindow,
                 kmer=kmer,
                 cores=cores)