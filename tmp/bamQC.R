fastqc

out_dir


bam
outdir_fastqc
threads
fastqc

system(paste(fastqc, '-o', output_fastqc, '-f bam', '--noextract', '-t', threads, bam))

flagstat_bam
samtools
bam
output_flagstat
threads

system(paste(samtools, 'flagstat -@', threads, bam, '>', output_flagstat))

module load MultiQC/1.9-foss-2019b-Python-3.7.4
multiqc='multiqc'

system(paste(multiqc,  -o 10multiQC -d -f -v -n multiQC_log 2> {log}

        """
mosdepth -n --fast-mode --by 500 sample.wgs $sample.wgs.cram

rule gatk_depth_of_coverage:
  input: "03indel_rln_recal_bam/{sample}_rln_recal.bam"
output: "03indel_rln_recal_bam_coverage/{sample}"
log: "00log/{sample}_depth_of_coverage.log"
message: "gatk depth of coverage for {input}"
shell:
  """
        java -jar {config[gatk_jar_path]} \
        -R {config[ref_fa]} \
        -T DepthOfCoverage \
        -o {output} \
        -I {input} \
        -ct 25 -ct 50 -ct 100 -ct 150 -ct 200 \
        -L {config[gatk_bam_coverage_interval]}
        """
