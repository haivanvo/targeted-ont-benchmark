#!/usr/bin/env bash
# cuteSV v1.0.8 — params per config/analysis_params.yaml -> variant_calling.sv[cuteSV]
set -euo pipefail
BAM="$1"; OUT="$2"
REF="data/reference/GRCh38.fa"
WORKDIR="${OUT}/cutesv_work"
mkdir -p "$WORKDIR"

cuteSV "$BAM" "$REF" "${OUT}/cutesv.vcf" "$WORKDIR" \
  --max_cluster_bias_INS 100 \
  --diff_ratio_merging_INS 0.3 \
  --max_cluster_bias_DEL 100 \
  --diff_ratio_merging_DEL 0.3
