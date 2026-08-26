#!/usr/bin/env bash
# Runs all SNV/Indel and SV callers for each sample.
# Individual tool wrapper scripts live alongside this one for clarity/reuse.
set -euo pipefail

for sample in HG001 HG002; do
  bam="data/aligned/${sample}.sorted.bam"
  out="results/variant_calls/${sample}"
  mkdir -p "$out"

  echo ">> [${sample}] Clair3"
  bash workflow/03_variant_calling/run_clair3.sh "$bam" "$out"

  echo ">> [${sample}] DeepVariant"
  bash workflow/03_variant_calling/run_deepvariant.sh "$bam" "$out"

  echo ">> [${sample}] FreeBayes"
  bash workflow/03_variant_calling/run_freebayes.sh "$bam" "$out"

  echo ">> [${sample}] cuteSV"
  bash workflow/03_variant_calling/run_cutesv.sh "$bam" "$out"

  echo ">> [${sample}] Sniffles2"
  bash workflow/03_variant_calling/run_sniffles2.sh "$bam" "$out"
done
