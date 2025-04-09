#!/usr/bin/env nextflow
process BOWTIE2_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'

    input:
    tuple val(meta), path(fastq)
    path bt2_idx
    val name

    output:
    tuple val(meta), path('*.bam'), emit: bam

    script:
    """
    bowtie2 -p 15 -x $bt2_idx/$name -U $fastq | samtools view -bS > ${meta}.bam
    """
}