#!/usr/bin/env bash
# Runs VEP, SnpEff, ANNOVAR (SNV/Indel + SV) and AnnotSV (SV only)
# on the best-performing caller's VCFs, per config/analysis_params.yaml.
set -euo pipefail

for sample in HG001 HG002; do
  in_vcf="results/variant_calls/${sample}/clair3.norm.vcf.gz"    # best SNV/Indel caller
  sv_vcf="results/variant_calls/${sample}/cutesv.vcf"            # best SV caller
  out="results/annotation/${sample}"
  mkdir -p "$out"

  echo ">> [${sample}] SnpEff"
  snpEff -v hg38 "$in_vcf" > "${out}/snpeff.vcf"

  echo ">> [${sample}] VEP"
  vep -i "$in_vcf" --assembly GRCh38 --vcf -o "${out}/vep.vcf"

  echo ">> [${sample}] ANNOVAR"
  table_annovar.pl "$in_vcf" humandb/ -buildver hg38 \
    -out "${out}/annovar" -vcfinput -remove -protocol refGene -operation g

  if [[ "$sample" == "HG002" ]]; then
    echo ">> [${sample}] AnnotSV (SV only, HG002 has validated SV calls)"
    AnnotSV -SVinputFile "$sv_vcf" -genomeBuild GRCh38 -outputDir "${out}/annotsv"
  fi
done
