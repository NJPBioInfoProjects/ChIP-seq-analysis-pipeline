# BF528 Project 2: ChIP-seq Nextflow Analysis Pipeline

## Overview

This project implements a reproducible bioinformatics workflow for analyzing ChIP-seq (Chromatin Immunoprecipitation followed by sequencing) data. The goal is to identify genome-wide binding sites of DNA-associated proteins and generate high-confidence peaks for downstream biological interpretation.

This pipeline performs quality control, read alignment, peak calling, and downstream analysis for ChIP-seq datasets using a modular, automated workflow (built with Nextflow). It is configured to run efficiently on high-performance computing clusters using Singularity or Conda environments.

Data used in original analysis orignated from Bartucu et al., 2016.

## Key Features
- Preprocessing: Quality control with FastQC and adapter trimming (if needed)
- Alignment: Mapping reads to a reference genome using Bowtie2
- Filtering: Removal of duplicates and low-quality reads
- Peak Calling: Identification of enriched regions using MACS3
- QC Reporting: MultiQC aggregation of metrics across all samples
- Motif analysis with HOMER and reproducibility assessment via IDR

## Usage

To run the nextflow pipeline:
1. Ensure you have created and activated conda environment that includes Nextflow
  
2. Run the pipeline:
   ```bash
   nextflow run main.nf -profile singularity,cluster
   ```
To use analysis notebook:
1. Ensure miniconda module is loaded:
   ```bash
   module load miniconda
   ```
2. Create analysis environment:
   ```bash
   conda env create -f envs/project2_analysis.yml
   ```
3. Select project2_analysis as Python environment

## Repo Structure:

├── envs/: Contains yml file for creating conda environment to run analysis notebook<br>
├── images/: Contains images displayed in analysis notebook<br>
├── modules/: Contains modules used in main.nf<br>
├── publication_data/: Contains RNAseq data from the publication for downstream analyses in tandem with ChIP-seq results<br>
├── README.md: Project overview and usage instructions<br>
├── analysis.ipynb: Provides an end-to-end demonstration of the ChIP-seq pipeline output, including quality control visualization, peak statistics, and optional motif analysis using downstream tools such as HOMER and DeepTools<br>
├── analysis.pdf: Readable and printable version of analysis.ipynb<br>
├── full_samplesheet.csv: File paths and sample names for each sample, used in nextflow.config<br>
├── main.nf: Main Nextflow pipeline that runs all processes contained within modules directory<br>
├── nextflow.config: Configuration file for references and cluster settings<br>
└── subset_samplesheet.csv: File paths and samples neames for each sample for test runs (smaller file sizes), used in nextflow.config<br>

## References
Barutcu AR, Hong D, Lajoie BR, McCord RP, van Wijnen AJ, Lian JB, Stein JL, Dekker J, Imbalzano AN, Stein GS. RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells. Biochim Biophys Acta. 2016 Nov;1859(11):1389-1397. doi: 10.1016/j.bbagrm.2016.08.003. Epub 2016 Aug 9. PMID: 27514584; PMCID: PMC5071180.
