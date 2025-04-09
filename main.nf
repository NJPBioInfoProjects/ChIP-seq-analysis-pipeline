#!/usr/bin/env nextflow

include { FASTQC } from './modules/fastqc/main.nf'
include { BOWTIE2_BUILD} from './modules/bowtie2_build/main.nf'
include { TRIM } from './modules/trim/main.nf'
include { BOWTIE2_ALIGN } from './modules/bowtie2_align/main.nf'
include { SAMTOOLS_FLAGSTAT } from "./modules/samtools_flagstat/main.nf"
include { MULTIQC } from "./modules/multiqc/main.nf"
include { SAMTOOLS_SORT } from "./modules/samtools_sort/main.nf"
include { SAMTOOLS_IDX } from "./modules/samtools_idx/main.nf"
include { BAMCOVERAGE } from "./modules/bamcoverage/main.nf"

workflow {
    Channel.fromPath(params.subset_samplesheet)
    | splitCsv( header: true )
    | map { row -> tuple(row.name, file(row.path)) }
    | set { read_ch }

    FASTQC(read_ch)
    BOWTIE2_BUILD(params.genome)
    TRIM(read_ch, params.adapter_fa)

    BOWTIE2_ALIGN(TRIM.out.trimmed, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.name)
    SAMTOOLS_FLAGSTAT(BOWTIE2_ALIGN.out.bam)

    TRIM.out.log.concat(FASTQC.out.zip, SAMTOOLS_FLAGSTAT.out.flagstat).collect()
    | set  { multiqc_ch }

    MULTIQC(multiqc_ch)

    // generate big wigs
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out) //big wigs require sorted BAMs, sorted BAms make it easy to index with samtools index
    SAMTOOLS_IDX(SAMTOOLS_SORT.out) //create indexes of sorted BAMs
    BAMCOVERAGE(SAMTOOLS_IDX.out.index) //create bigWigs

    //week2

    // BAMCOVERAGE.out.bigwig.collect{ it[1] }
    // | set { bws_ch }

    // MULTIBWSUMMARY(bws_ch)

    // BOWTIE2_ALIGN.out
    // | map { name, path -> tuple(name.split('_')[1], [(path.baseName.split('_')[0]): path]) }

    // CALLPEAKS(peakcalling_ch, params.macs3_genome)

}
