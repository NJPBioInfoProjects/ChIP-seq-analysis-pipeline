#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_low'
    conda 'envs/samtools_env.yml'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir

    input:
    tuple val(meta), path(bam)

    output:
    path('*flagstat.txt'), emit: flagstat

    script:
    """
    samtools flagstat -@ $task.cpus $bam > ${meta}_flagstat.txt
    """
}