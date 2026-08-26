#!/usr/bin/env bash
# QC (NanoStat) + filtering (Chopper) for each sample.
# Parameters are read from config/analysis_params.yaml (min_quality, min_length).
set -euo pipefail

CONFIG="config/analysis_params.yaml"
MIN_Q=$(yq '.preprocessing.min_quality' "$CONFIG")
MIN_LEN=$(yq '.preprocessing.min_length' "$CONFIG")

for sample in HG001 HG002; do
  raw_fastq="data/raw/${sample}.fastq.gz"
  out_dir="results/qc/${sample}"
  mkdir -p "$out_dir"

  echo ">> [${sample}] Pre-filter QC (NanoStat)"
  NanoStat --fastq "$raw_fastq" --outdir "$out_dir" -n "${sample}_prefilter_stats.txt"

  echo ">> [${sample}] Filtering with Chopper (Q>=${MIN_Q}, length>=${MIN_LEN})"
  gunzip -c "$raw_fastq" | chopper -q "$MIN_Q" -l "$MIN_LEN" | gzip > "data/processed/${sample}.filtered.fastq.gz"

  echo ">> [${sample}] Post-filter QC (NanoStat)"
  NanoStat --fastq "data/processed/${sample}.filtered.fastq.gz" --outdir "$out_dir" -n "${sample}_postfilter_stats.txt"
done
