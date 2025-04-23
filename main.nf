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
include { MULTIBWSUMMARY } from "./modules/multibwsummary/main.nf"
include { PLOTCORRELATION } from "./modules/plotcorrelation/main.nf"
include { CALLPEAKS } from "./modules/callpeaks/main.nf"
include { INTERSECT } from "./modules/intersect/main.nf"
include { REMOVE } from "./modules/remove/main.nf"
include { ANNOTATEPEAKS } from "./modules/annotatepeaks/main.nf"
include { COMPUTEMATRIX } from "./modules/computematrix/main.nf"
include { PLOTPROFILE } from "./modules/plotprofile/main.nf"
include { FINDMOTIFSGENOME } from "./modules/findmotifsgenome/main.nf"

workflow {
    Channel.fromPath(params.samplesheet)
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

    BAMCOVERAGE.out.bigwig.collect{ it[1] }
    | set { bws_ch }

    MULTIBWSUMMARY(bws_ch)

    PLOTCORRELATION(MULTIBWSUMMARY.out.multibwsummary, 'spearman') // use spearman, as it is rank-based

    BOWTIE2_ALIGN.out
    | map { name, path -> tuple(name.split('_')[1], [(path.baseName.split('_')[0]): path]) }
    | groupTuple(by: 0)
    | map { rep, maps -> tuple(rep, maps[0] + maps[1])}
    | map { rep, samples -> tuple(rep, samples.IP, samples.INPUT)}
    | set { peakcalling_ch }

    
    // The peak calling many not work due to known bug
    
    CALLPEAKS(peakcalling_ch, params.macs3_genome) // need to put the genome in params

    CALLPEAKS.out.peaks.collect{ it[1] }
    | map {files -> tuple('repr_peaks', files[0], files[1])}
    | set { intersect_ch }

    INTERSECT(intersect_ch)
    
    REMOVE(INTERSECT.out.intersect, params.blacklist)

    ANNOTATEPEAKS(REMOVE.out.filtered, params.genome, params.gtf)

    // week 3
    COMPUTEMATRIX(BAMCOVERAGE.out.bigwig, params.hg38, 2000)
    PLOTPROFILE(COMPUTEMATRIX.out.matrix)

    FINDMOTIFSGENOME(REMOVE.out.filtered, params.genome)



}
