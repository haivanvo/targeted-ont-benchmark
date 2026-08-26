#!/usr/bin/env bash
# Align filtered reads to GRCh38 with minimap2 (map-ont preset), sort + index with samtools.
set -euo pipefail

REF="data/reference/GRCh38.fa"
mkdir -p data/aligned

for sample in HG001 HG002; do
  fastq="data/processed/${sample}.filtered.fastq.gz"
  bam="data/aligned/${sample}.sorted.bam"

  echo ">> [${sample}] minimap2 alignment"
  minimap2 -ax map-ont "$REF" "$fastq" \
    | samtools sort -o "$bam" -
  samtools index "$bam"

  echo ">> [${sample}] Alignment stats"
  samtools flagstat "$bam" > "results/qc/${sample}/${sample}.flagstat.txt"
done
