# Thesis Alignment Table
**Benchmarking Variant Calling and Functional Annotation Tools on Targeted Nanopore Long-Read Data — Vo Hai Van**

A methods-to-results traceability check: every claim/parameter stated in Section 2 (Materials and Methods) mapped to where it is confirmed (or not) in Section 3 (Results) and Discussion.

| Methods statement | Methods section | Evidence/status in Results |
|---|---|---|
| Two ONT targeted sequencing runs used: HG001 (ERR8578834), HG002 (ERR8578835), BioProject PRJEB50895 | 2.2.1 | ✅ Exact — Appendix B, Table 3 |
| QC via NanoStat; filtering via Chopper (Q<20 or <500bp removed) | 2.2.3 | ✅ Confirmed — 3.1, Appendix B Table 4; pre/post-filter QC shown in Fig. 4–5 |
| Alignment: minimap2 `-ax map-ont` against GRCh38 | 2.2.3 | ✅ Confirmed — 3.1: mapping rates 97.25% (HG001), 96.31% (HG002), Table 5 |
| SNV/Indel callers: DeepVariant v1.6.1, FreeBayes v1.3.10, Clair3 v1.2.0 | Table 1 | ✅ Confirmed — 3.2, Fig. 6–7, Table 6 |
| SV callers: cuteSV v1.0.8, Sniffles2 v2.6.3 | Table 1 | ✅ Confirmed — 3.2, Fig. 8, Table 6 |
| Benchmarking via RTG vcfeval (SNV/Indel) and Truvari (SV) | 2.3.1 | ✅ Confirmed — metrics reported per tool in Table 6 |
| GIAB v4.2.1 truth set used for both HG001 & HG002 (SNV/Indel) | 2.2.4 | ✅ Confirmed — Table 6 shows both samples benchmarked |
| GIAB CMRG v1.0 truth set used for HG002 only (SV); HG001 SV not benchmarked (no truth set) | 2.2.4 | ✅ Confirmed — 3.2 explicitly states SV callers "exclusively evaluated on HG002" |
| VCF normalization via bcftools before benchmarking | 2.2.4 | ⚠️ Not directly re-confirmed with output/numbers in Results — stated as a preprocessing step only, no QC metric reported for it. Worth a one-line confirmation if you want the loop fully closed. |
| Annotation tools: SnpEff v5.4a, VEP v115.2, ANNOVAR v2022-08-02, AnnotSV v3.5.5 | Table 1 | ✅ Confirmed — 3.3, Fig. 9–11 |
| nanotatoR excluded (SMAP-only input incompatible with VCF output) | 2.2.2 | ✅ Consistent — stated once as a scoping decision, never contradicted later |
| SNV/Indel consequence concordance: VEP, SnpEff, ANNOVAR only (AnnotSV excluded — SV-only tool) | 2.2.5 | ✅ Confirmed — Fig. 9–10 show exactly these three tools |
| SV gene-level consensus across all four annotation tools, ≥2-tool agreement threshold | 2.2.5 | ✅ Confirmed — Fig. 11; 4 genes (PRKRA, OVGP1, SEMG1, KRTAP1-1) identified by all four |
| Computational split: GPU (DeepVariant, Linux/RTX 3060) vs CPU (everything else, macOS M4) | 2.2.2 | ✅ Confirmed — Table 6 shows CPU/GPU rows for Clair3 & DeepVariant are numerically identical, supporting the Discussion's claim that "GPU acceleration does not affect variant-calling accuracy, only runtime" |
| Abstract claim: Clair3 precision "over 95%" | Abstract | ✅ Consistent — Results report 95.44% (HG001) and 95.17% (HG002), Table 6 |
| Abstract claim: cuteSV outperforms Sniffles2 for SVs | Abstract | ✅ Consistent — cuteSV F1 68.97% vs Sniffles2 F1 0.00% (no calls), Fig. 8 |

## Notes / things worth double-checking before submission
- The **bcftools normalization step** (2.2.4) is stated but never referenced again with a specific outcome — consider adding a brief sentence in Results confirming it was applied uniformly, since a reader could otherwise wonder if it happened.
- **KRTAP1-1 transcript version discrepancy** (Discussion, p.21–22): you already explain this well (SnpEff used an older NM_030967 build vs. the others), but it's worth double-checking this is stated consistently in both the Results caption for Table 9 and the Discussion — right now the explanation only lives in Discussion.
- Table 6 has a tiny inconsistency worth checking: HG002 Clair3 CPU reports TP=83,819 while GPU reports TP=83,818 (off by one), yet Precision/Recall/F1 are listed identically (95.17/87.71/91.29) for both. Not necessarily wrong (rounding), but a reviewer might ask about it — worth a one-line note or footnote if intentional.
