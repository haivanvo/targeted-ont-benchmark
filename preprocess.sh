# Installation
conda activate thesis
conda install -c bioconda -c conda-forge nanostat chopper -y

# Quality control 
NanoStat --fastq HG001.fastq \
-o ~/data_thesis/HG001 \
-n HG001_rpt

# Trimming
chopper --minlength 1000 -i ~/data_thesis/HG001/HG001.fastq > ~/data_thesis/HG001/HG001_filtered.fastq 
