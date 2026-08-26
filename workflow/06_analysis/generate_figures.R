# Generates thesis figures (6-11) and summary tables from benchmarking/annotation output.
# Run with: Rscript workflow/06_analysis/generate_figures.R

library(tidyverse)

bench_dir <- "results/benchmarking"
annot_dir <- "results/annotation"
fig_dir   <- "results/figures"
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

# --- Figures 6-7: SNV/Indel caller benchmarking (Precision/Recall/F1 per sample) ---
snv_metrics <- read_tsv(file.path(bench_dir, "snv_indel_summary.tsv"))
# ... bar chart faceted by sample, one bar group per caller/compute-env, see thesis Fig. 6-7

# --- Figure 8: SV caller benchmarking (HG002 only) ---
sv_metrics <- read_tsv(file.path(bench_dir, "sv_summary.tsv"))
# ... bar chart, cuteSV vs Sniffles2

# --- Figures 9-10: functional consequence distribution per annotation tool ---
consequence_counts <- read_tsv(file.path(annot_dir, "consequence_counts.tsv"))
# ... stacked bar chart, log10 scale, per sample

# --- Figure 11: SV gene-level concordance dot plot ---
sv_gene_concordance <- read_tsv(file.path(annot_dir, "sv_gene_concordance.tsv"))
# ... dot plot, size = SV count, faceted/colored by tool

# TODO: fill in ggplot2 calls matching thesis figure style, then ggsave() each to fig_dir
