export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

SAMPLE=/path/to/user
REF=/path/to/ref/fasta
MODEL=/path/to/model
OUTDIR=/path/to/output

python3 /path/to/clair3/run_clair3.py \
  --bam_fn=${SAMPLE}/HG001.bam \
  --ref_fn=${REF}/GRCh38_no_alt_analysis_set.fasta \
  --sample_name=HG001 \
  --threads=4 \
  --platform=ont \
  --model_path=${MODEL} \
  --output=${OUTDIR} \
  --qual=10 # optional 
