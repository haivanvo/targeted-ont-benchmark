export PATH=$PATH:/Users/haivanvo/sratoolkit.3.2.1-mac-x86_64/bin
which fasterq-dump # Make sure it's correct before converting into fastq file
prefetch ERR8578835
fasterq-dump --outdir ~/data_thesis 

# Run NanoPlot to check status
nanoplot --fastq ~/sra/HG001.fastq \
  --title "HG001_QC" \
  --outdir ~/sra/nanoplot_out \
  --tsv_stats \
  --N50 \
-f # choose png/pdf/webpage/jpg...

# Installation
conda activate thesis
conda install -c bioconda -c conda-forge nanostat chopper -y

# Quality control 
NanoStat --fastq HG001.fastq \
-o ~/data_thesis/HG001 \
-n HG001_rpt

# Trimming
chopper --minlength 1000 -i ~/data_thesis/HG001/HG001.fastq > ~/data_thesis/HG001/HG001_filtered.fastq 
