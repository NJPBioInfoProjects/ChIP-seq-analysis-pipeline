# BF528 Project 2: ChIP-seq Nextflow Analysis Pipeline

## Overview

This project implements a reproducible bioinformatics workflow for analyzing ChIP-seq (Chromatin Immunoprecipitation followed by sequencing) data. The goal is to identify genome-wide binding sites of DNA-associated proteins and generate high-confidence peaks for downstream biological interpretation.

This pipeline performs quality control, read alignment, peak calling, and downstream analysis for ChIP-seq datasets using a modular, automated workflow (built with Nextflow). It is configured to run efficiently on high-performance computing clusters using Singularity or Conda environments.

## Key Features
- Preprocessing: Quality control with FastQC and adapter trimming (if needed)
- Alignment: Mapping reads to a reference genome using Bowtie2
- Filtering: Removal of duplicates and low-quality reads
- Peak Calling: Identification of enriched regions using MACS3
- QC Reporting: MultiQC aggregation of metrics across all samples
- Motif analysis with HOMER and reproducibility assessment via IDR

## Repo Structure:

├── envs/: Contains yml file for creating conda environment to run analysis notebook<br>
├── images/: Contains images displayed in analysis notebook<br>
├── modules/: Contains modules used in main.nf<br>
├── publication_data/: Contains RNAseq data from the publication for downstream analyses in tandem with ChIP-seq results<br>
├── README.md: Project overview and usage instructions<br>
├── analysis.ipynb: Provides an end-to-end demonstration of the ChIP-seq pipeline output, including quality control visualization, peak statistics, and optional motif analysis using downstream tools such as HOMER and DeepTools

├── nextflow.config       # Configuration file for references and cluster settings<br>
├── main.nf               # Main Nextflow pipeline<br>
├── refs/                 # Reference genome files (FASTA, GTF, etc.)<br>
├── results/              # Output directory for results<br>
└── Singularity.def       # Singularity definition file (if used)<br>

## Directions for Project 2

You may find the directions for each week of project 2 in `refs/` as well
as in the textbook if you prefer (https://bu-bioinfo.github.io/bf528/week-1-chipseq.html)

Please push your progress regularly to this repo and on each following Friday
with your completed tasks for the previous week. 
