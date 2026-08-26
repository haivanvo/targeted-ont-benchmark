# Benchmarking Variant Calling and Functional Annotation Tools on Targeted Nanopore Long-Read Data

B.S. Biotechnology thesis — School of Biotechnology, International University (VNU-HCMC)

> Evaluates SNV/Indel and structural variant (SV) callers, plus four functional annotation tools, on ONT targeted (medical exome) long-read sequencing data.

## Summary

This repository contains the full analysis pipeline, configuration, and code used to benchmark:
- **SNV/Indel callers:** Clair3, DeepVariant, FreeBayes
- **SV callers:** cuteSV, Sniffles2
- **Annotation tools:** VEP, SnpEff, ANNOVAR, AnnotSV

on two GIAB reference samples (HG001/NA12878, HG002/NA24385) sequenced with ONT targeted capture (SQK-LSK109, MinION).

**Key finding:** Clair3 (precision >95%) was the best-performing SNV/Indel caller; cuteSV outperformed Sniffles2 for SV detection. Annotation tools showed strong gene-level concordance but disagreed on specific functional consequence calls for the same variant, largely due to transcript database version differences.

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
├── docs/                     # Extended methods notes, thesis alignment table
├── environment.yml           # Conda environment (tool versions pinned)
├── CITATION.cff
└── LICENSE
```

## Reproducing the pipeline

```bash
# 1. Clone and set up environment
git clone https://github.com/<your-username>/nanopore-variant-benchmark.git
cd nanopore-variant-benchmark
conda env create -f environment.yml
conda activate nanopore-benchmark

# 2. Fetch data (see data/README.md for accessions)
bash workflow/01_preprocessing/00_download_sra.sh

# 3. Run the pipeline end-to-end
bash workflow/01_preprocessing/run_qc_filter.sh
bash workflow/02_alignment/run_minimap2.sh
bash workflow/03_variant_calling/run_all_callers.sh
bash workflow/04_benchmarking/run_benchmarking.sh
bash workflow/05_annotation/run_all_annotators.sh
Rscript workflow/06_analysis/generate_figures.R
```

Each stage's scripts read shared parameters from `config/analysis_params.yaml`, so tool versions/models only need to be changed in one place.

## Data

| Sample | Accession | Platform | Kit |
|---|---|---|---|
| HG001 (NA12878) | ERR8578834 | ONT MinION | SQK-LSK109 |
| HG002 (NA24385) | ERR8578835 | ONT MinION | SQK-LSK109 |

Source: NCBI SRA, BioProject [PRJEB50895](https://www.ncbi.nlm.nih.gov/bioproject/PRJEB50895) (Leung et al., 2022). See `data/metadata/samples.tsv`.

Targeted BED file: [ECNano `mes_with_gene.hg38_nochr.bed`](https://github.com/HKU-BAL/ECNano/blob/main/bed/mes_with_gene.hg38_nochr.bed)

Ground truth: GIAB high-confidence calls v4.2.1 (SNV/Indel); GIAB CMRG v1.0 (SV, HG002 only).

## Tool versions

See `config/analysis_params.yaml` and `environment.yml` for the exact pinned versions used (Clair3 v1.2.0, DeepVariant v1.6.1, FreeBayes v1.3.10, cuteSV v1.0.8, Sniffles2 v2.6.3, VEP v115.2, SnpEff v5.4a, ANNOVAR 2022-08-02, AnnotSV v3.5.5).

## Citation

If you use this pipeline, please cite the thesis (see `CITATION.cff`).

## License

MIT — see `LICENSE`. Reference data (GIAB, SRA) retains its original licensing/attribution terms.
