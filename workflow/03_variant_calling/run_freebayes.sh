#!/usr/bin/env bash
# FreeBayes v1.3.10, default parameters
set -euo pipefail
BAM="$1"; OUT="$2"
REF="data/reference/GRCh38.fa"

freebayes -f "$REF" "$BAM" > "${OUT}/freebayes.vcf"
bgzip -f "${OUT}/freebayes.vcf"
tabix -p vcf "${OUT}/freebayes.vcf.gz"
