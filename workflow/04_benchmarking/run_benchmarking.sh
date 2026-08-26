#!/usr/bin/env bash
# Normalize VCFs (bcftools), then benchmark:
#   SNV/Indel callers -> RTG vcfeval against GIAB v4.2.1
#   SV callers        -> Truvari against GIAB CMRG v1.0 (HG002 only)
set -euo pipefail

BED="data/reference/mes_with_gene.hg38_nochr.bed"
TRUTH_SNV="data/reference/truth_sets/GIAB_v4.2.1"
TRUTH_SV_HG002="data/reference/truth_sets/GIAB_CMRG_v1.0_HG002.vcf.gz"

for sample in HG001 HG002; do
  vc_dir="results/variant_calls/${sample}"
  bench_dir="results/benchmarking/${sample}"
  mkdir -p "$bench_dir"

  for tool in clair3 deepvariant freebayes; do
    raw_vcf="${vc_dir}/${tool}.vcf.gz"
    norm_vcf="${vc_dir}/${tool}.norm.vcf.gz"

    echo ">> [${sample}/${tool}] Normalizing with bcftools"
    bcftools norm -f data/reference/GRCh38.fa -O z -o "$norm_vcf" "$raw_vcf"
    tabix -p vcf "$norm_vcf"

    echo ">> [${sample}/${tool}] RTG vcfeval"
    rtg vcfeval \
      -b "${TRUTH_SNV}/${sample}.vcf.gz" \
      -c "$norm_vcf" \
      -e "$BED" \
      -t data/reference/GRCh38.sdf \
      -o "${bench_dir}/${tool}_vcfeval"
  done
done

# SV benchmarking — HG002 only (no validated SV truth set for HG001)
for tool in cutesv sniffles2; do
  raw_vcf="results/variant_calls/HG002/${tool}.vcf"
  echo ">> [HG002/${tool}] Truvari"
  truvari bench \
    -b "$TRUTH_SV_HG002" \
    -c "$raw_vcf" \
    --includebed "$BED" \
    -o "results/benchmarking/HG002/${tool}_truvari"
done
