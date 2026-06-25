# Targeted ONT Variant Calling and Annotation Benchmark ݁ 

Note: Full implementation is withheld pending publication. This README includes the methodology and workflow only.

## Overview  
This repository currently serves an overview and workflow documentation of my bachelor thesis project:
**“Benchmarking variant calling and functional annotation tools on targeted Nanopore long-read  data.”** conducted by Hai Van Vo, under the supervision of Dr. Minh Thong Le, School of Biotechnology, International University (Vietnam National University HCMC).

The aim of this project is to systematically evaluate and compare different variant calling and annotation tools on a simulated targeted long-read sequencing dataset based on Nanopore error profiles, in order to identify reliable and efficient tools for accurate variant detection and functional interpretation.


---

## Workflow design

1. **Data acquisition**

My thesis project specifically used the HG001 (ERR8578834) and HG002 (ERR8578835) sequencing runs provided in NCBI database, under the accession number of PRJEB50895. The data was originally published by Leung et al. (2022) under the title "ECNano: A cost-effective workflow for target enrichment sequencing and accurate variant calling on 4800 clinically significant genes using a single MinION flowcell)".

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
  
---





