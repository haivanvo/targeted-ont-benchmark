#!/usr/bin/env bash
# Clair3 v1.2.0 — model: r941_prom_sup_g5014 (see config/analysis_params.yaml)
set -euo pipefail
BAM="$1"; OUT="$2"
REF="data/reference/GRCh38.fa"
MODEL="models/r941_prom_sup_g5014"

run_clair3.sh \
  --bam_fn="$BAM" \
  --ref_fn="$REF" \
  --threads=8 \
  --platform="ont" \
  --model_path="$MODEL" \
  --output="${OUT}/clair3"
