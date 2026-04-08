export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

python3 run_clair3.py \
  --bam_fn=/Users/haivanvo/HG001.bam \
  --ref_fn=/Users/haivanvo/data_thesis/GRCh38_no_alt_analysis_set.fasta \
  --sample_name=HG001 \
  --threads=4 \
  --platform=ont \
  --model_path=/Users/haivanvo/mamba/envs/clair3/bin/models/r941_e82_400bps_sup_v500 \
  --output=/Users/haivanvo/tools/Clair3/HG001 \
  --qual=10
