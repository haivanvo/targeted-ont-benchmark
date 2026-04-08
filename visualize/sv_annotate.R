# SV annotation concordance analysis
# Compares gene-level SV detection across AnnotSV, ANNOVAR, SnpEff, and VEP

library(tidyverse)

# AnnotSV 

anno <- read_tsv("data/HG002_cuteSV_AnnotSV.tsv")

anno <- anno %>%
  mutate(
    is_precise   = str_detect(INFO, "PRECISE"),
    is_imprecise = str_detect(INFO, "IMPRECISE")
  )

# Filter for PASS and PRECISE variants
anno_filtered <- anno %>%
  filter(FILTER == "PASS", is_precise == TRUE)

# Split genes separated by ";" into separate rows
anno_variants_clean <- anno_filtered %>%
  mutate(variant_id = paste(SV_chrom, SV_start, SV_end, sep = ":")) %>%
  separate_rows(Gene_name, sep = ";") %>%
  distinct()

# Gene-level presence matrix
anno_presence <- anno_variants_clean %>%
  select(variant_id, Gene_name) %>%
  mutate(present = 1) %>%
  pivot_wider(id_cols = variant_id,
              names_from = Gene_name,
              values_from = present,
              values_fill = 0)

# Variants per gene
annotsv_gene_df <- colSums(anno_presence[, -1]) %>%
  enframe(name = "gene", value = "variants") %>%
  arrange(desc(variants)) %>%
  mutate(tool = "AnnotSV")


# ANNOVAR 

annovar <- read_table("data/annovar/HG002_cuteSV_anv.hg38_multianno.txt")

annovar_genes <- annovar %>%
  mutate(
    variant_id = paste(Chr, Start, End, sep = ":"),
    Gene = Gene.refGeneWithVer
  ) %>%
  select(variant_id, Gene) %>%
  separate_rows(Gene, sep = ",") %>%
  distinct() %>%
  mutate(tool = "ANNOVAR")

annovar_presence <- annovar_genes %>%
  distinct(variant_id, Gene) %>%
  mutate(present = 1) %>%
  pivot_wider(id_cols = variant_id,
              names_from = Gene,
              values_from = present,
              values_fill = 0)

annovar_gene_df <- colSums(annovar_presence[, -1]) %>%
  enframe(name = "gene", value = "variants") %>%
  arrange(desc(variants)) %>%
  mutate(tool = "ANNOVAR")

# SnpEff

snpeff <- read_table("data/snpeff/HG002_cuteSV_anv.hg38_multianno.txt")

snpeff_genes <- annovar %>%
  mutate(
    variant_id = paste(Chr, Start, End, sep = ":"),
    Gene = Gene.refGeneWithVer
  ) %>%
  select(variant_id, Gene) %>%
  separate_rows(Gene, sep = ",") %>%
  distinct() %>%
  mutate(tool = "SnpEff")

snpeff_presence <- annovar_genes %>%
  distinct(variant_id, Gene) %>%
  mutate(present = 1) %>%
  pivot_wider(id_cols = variant_id,
              names_from = Gene,
              values_from = present,
              values_fill = 0)

snpeff_gene_df <- colSums(annovar_presence[, -1]) %>%
  enframe(name = "gene", value = "variants") %>%
  arrange(desc(variants)) %>%
  mutate(tool = "SnpEff")

# VEP

vep <- read_table("data/vep/HG002_cuteSV_anv.hg38_multianno.txt")

vep_genes <- annovar %>%
  mutate(
    variant_id = paste(Chr, Start, End, sep = ":"),
    Gene = Gene.refGeneWithVer
  ) %>%
  select(variant_id, Gene) %>%
  separate_rows(Gene, sep = ",") %>%
  distinct() %>%
  mutate(tool = "VEP")

vep_presence <- annovar_genes %>%
  distinct(variant_id, Gene) %>%
  mutate(present = 1) %>%
  pivot_wider(id_cols = variant_id,
              names_from = Gene,
              values_from = present,
              values_fill = 0)

vep_gene_df <- colSums(annovar_presence[, -1]) %>%
  enframe(name = "gene", value = "variants") %>%
  arrange(desc(variants)) %>%
  mutate(tool = "VEP")


# Merge all tools 


all_gene_counts <- bind_rows(
  annotsv_gene_df,
  annovar_gene_df,
  snpeff_gene_df,
  vep_gene_df
)

gene_comparison <- all_gene_counts %>%
  pivot_wider(id_cols = gene,
              names_from = tool,
              values_from = variants,
              values_fill = 0) %>%
  mutate(
    total         = AnnotSV + ANNOVAR + SnpEff + VEP,
    tools_detected = (AnnotSV > 0) + (ANNOVAR > 0) + (SnpEff > 0) + (VEP > 0)
  )

# Genes detected by 2 or more tools
gene_comparison %>%
  filter(tools_detected >= 2) %>%
  arrange(desc(total), desc(tools_detected)) %>%
  print()


# Dot plot 

multi_tool_genes <- gene_comparison %>%
  filter(tools_detected >= 2) %>%
  arrange(desc(tools_detected), desc(SnpEff))

all_long <- all_gene_counts %>%
  filter(gene %in% multi_tool_genes$gene) %>%
  rename(count = variants)

ggplot(all_long, aes(x = tool, y = reorder(gene, count), size = count, color = tool)) +
  geom_point() +
  labs(x = "Tool", y = "Gene", size = "Variant count") +
  theme_classic() +
  theme(
    axis.text.y    = element_text(size = 6),
    legend.position = "right"
  )

ggsave("concordance_SV.png", width = 11, height = 7, dpi = 300)
