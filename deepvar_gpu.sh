#!/bin/bash
set -euo pipefail

# 1. Define variables
INPUT_DIR="/user/input"
OUTPUT_DIR="${INPUT_DIR}/output_dv"
BIN_VERSION="1.6.0"
MODEL_TYPE="ONT_R104"
SAMPLE="HG001"

# 2. Create output and tmp directories
mkdir -p "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}/tmp${SAMPLE}"

# 3. Run DeepVariant with GPU
singularity run --nv \
  -B /usr/lib/locale/:/usr/lib/locale/ \
  -B "${INPUT_DIR}":/input \
  -B "${OUTPUT_DIR}":/output \
  docker://google/deepvariant:"${BIN_VERSION}-gpu" \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type="${MODEL_TYPE}" \
  --ref=/input/GRCh38_no_alt_analysis_set.fasta \
  --reads=/input/${SAMPLE}_filtered_mapped_sorted.bam \
  --output_vcf=/output/${SAMPLE}_dv.vcf.gz \
  --num_shards=$(nproc) \
  --intermediate_results_dir=/output/tmp${SAMPLE}
