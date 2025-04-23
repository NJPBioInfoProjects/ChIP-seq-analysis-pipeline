#!/usr/bin/env nextflow

process INTERSECT {
    label 'process_low'
    conda 'envs/bedtools_env.yml'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple path(bedA), path(bedB)

    output:
    path("repr_peaks.bed"), emit: intersect

    script:
    """
    bedtools intersect -a $bedA -b $bedB -f .5 -r > repr_peaks.bed
    """
}