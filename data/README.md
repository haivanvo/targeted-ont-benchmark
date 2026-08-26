# Data

Raw sequencing data and the reference genome are **not tracked in this repository** (too large for git). This folder documents what's needed and where to get it.

## Raw reads

| Sample | Accession | Fetch command |
|---|---|---|
| HG001 | ERR8578834 | `prefetch ERR8578834 && fasterq-dump ERR8578834` |
| HG002 | ERR8578835 | `prefetch ERR8578835 && fasterq-dump ERR8578835` |

(Requires [SRA Toolkit](https://github.com/ncbi/sra-tools).)

## Reference genome

GRCh38 (hg38), no `chr` prefix to match the target BED file:
```bash
wget -O data/reference/GRCh38.fa.gz <GRCh38 no-alt FASTA URL>
gunzip data/reference/GRCh38.fa.gz
samtools faidx data/reference/GRCh38.fa
```

## Target regions

```bash
wget -O data/reference/mes_with_gene.hg38_nochr.bed \
  https://raw.githubusercontent.com/HKU-BAL/ECNano/main/bed/mes_with_gene.hg38_nochr.bed
```

## Ground truth sets

- GIAB high-confidence SNV/Indel calls v4.2.1 (HG001 & HG002) — [GIAB FTP](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/)
- GIAB Challenging Medically Relevant Genes (CMRG) v1.0 (HG002 only, used for SV benchmarking)

Place downloaded truth VCFs under `data/reference/truth_sets/`.
