#!/usr/bin/env bash
# Sniffles2 v2.6.3, default parameters
set -euo pipefail
BAM="$1"; OUT="$2"
REF="data/reference/GRCh38.fa"

sniffles --input "$BAM" --reference "$REF" --vcf "${OUT}/sniffles2.vcf"
