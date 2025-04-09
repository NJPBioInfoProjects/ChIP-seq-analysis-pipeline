#!/usr/bin/env nextflow

process FASTQC {
    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    conda 'envs/fastqc_env.yml'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.html")
    path("*.zip"), emit: zip

    script:
    """
    fastqc -t $task.cpus ${reads}
    """
}