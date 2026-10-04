# Targeted ONT Variant Calling and Annotation Benchmark ݁ 


## Overview  
This repository currently serves an overview and workflow documentation of my bachelor thesis project:
**“Benchmarking variant calling and functional annotation tools on targeted Nanopore long-read  data.”** conducted by Hai Van VO, under the supervision of Dr. Minh Thong LE, School of Biotechnology, International University (Vietnam National University HCMC).

The aim of this project is to systematically evaluate and compare different variant calling and annotation tools on a real targeted long-read sequencing dataset in order to identify reliable and efficient tools for accurate variant detection and functional annotation.



## Repository structure

```
.
├── config/                  # Pipeline parameters, tool versions, models
│   └── analysis_params.yaml
├── data/
│   ├── metadata/             # Sample sheet, accessions (tracked)
│   └── reference/            # Reference genome, BED file (gitignored — see data/README.md)
├── workflow/
│   ├── 01_preprocessing/     # NanoStat QC, Chopper filtering
│   ├── 02_alignment/         # minimap2 -> sorted/indexed BAM
│   ├── 03_variant_calling/   # Clair3, DeepVariant, FreeBayes, cuteSV, Sniffles2
│   ├── 04_benchmarking/      # bcftools normalization, RTG vcfeval, Truvari
│   ├── 05_annotation/        # VEP, SnpEff, ANNOVAR, AnnotSV
│   └── 06_analysis/          # R scripts for figures & summary tables
├── results/
│   ├── qc/                   # NanoPlot reports, alignment stats
│   ├── benchmarking/         # Precision/Recall/F1 tables (TP/FP/FN)
│   └── figures/              # Final manuscript figures
├── environment.yml           # Conda environment (tool versions pinned)
├── CITATION.cff
└── LICENSE
```

## Workflow design

<img width="2316" height="8192" alt="Thesis Workflow" src="https://github.com/user-attachments/assets/741a73a3-c34f-4207-855f-8e8999a561ae" />


1. **Data acquisition**

My thesis project specifically used the HG001 (ERR8578834) and HG002 (ERR8578835) sequencing runs provided in NCBI database, under the accession number of PRJEB50895. The data was originally published by Leung et al. in 2022. (DOI: [10.1186/s12920-022-01190-3]([url](https://pubmed.ncbi.nlm.nih.gov/35246132/)))

2. **QC**

Used NanoStat (v1.46.1) to assess the quality of reads.

3. **Preprocessing**

Used Chopper (v0.10.0) to filter low-quality reads.

4. **Alignment**

Used minimap2 (v2.30-r1287) and GRCh38 reference genome for mapping, samtools to convert SAM -> BAM for variant calling.

5. **Variant calling and Benchmarking**
- Variant callers:

| Tool        | Variant type detection | 
|-------------|-----------|
| cuteSV    | SVs        | 
| Sniffles2    | SVs       | 
| DeepVariant | SNVs, indels        | 
| Clair3 | SNVs, indels | 
| FreeBayes | SNVs, indels | 

(Since DeepVariant didn't support R9 model, I used R10 model for my R9 dataset instead, therefore, the accuracy was affected. To use R9 model, we can use PEPPER-Margin-DeepVariant, though this tool wasn't supported by Google so I didn't include in my thesis).

- Truth set (Note that for HG001 sample, there wasn't a relevant SV truth set):
  + GIAB truth set
    
    HG001: https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv4.2.1/GRCh38/
    
    HG002: https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/AshkenazimTrio/HG002_NA24385_son/NIST_SV_v0.6/
    
    HG002 (SV): https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/AshkenazimTrio/HG002_NA24385_son/CMRG_v1.00/GRCh38/StructuralVariant/
    
  + Targeted BED panel (https://github.com/HKU-BAL/ECNano/blob/main/bed/mes_with_gene.hg38_nochr.bed) to intersect with GIAB truth set
 
- Metrics: F1-score, Precision, Recall.
  
- Benchmarking tools: RTG vcfeval (for SNV/Indel callers), Truvari (for SV callers)
 
6. **Functional annotation and Benchmarking**
- Annotation software: VEP, ANNOVAR, AnnotSV, SnpEff

- Benchmarking method: Comparative analysis among 4 softwares
  






