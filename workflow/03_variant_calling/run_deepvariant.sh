#!/usr/bin/env bash
# DeepVariant v1.6.1, model_type=ONT_R104. Run via Singularity on the GPU server
# (Ubuntu 20.04.6 LTS, RTX 3060) — see config/analysis_params.yaml -> compute.gpu_env
set -euo pipefail
BAM="$1"; OUT="$2"
REF="data/reference/GRCh38.fa"

singularity exec --nv docker://google/deepvariant:1.6.1 \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type=ONT_R104 \
  --ref="$REF" \
  --reads="$BAM" \
  --output_vcf="${OUT}/deepvariant.vcf.gz" \
  --num_shards=8
