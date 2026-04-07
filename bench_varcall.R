## FOR SNV CALLERS
# Load library
library(ggplot2)
library(tidyverse)
library(readr)

# Read table 
clair3cpu <- read_table("data/HG001_SNV_intersect_benchmark/benchmark_clair3cpu/summary.txt", comment = "-"))
clair3gpu <- read_table("data/HG001_SNV_intersect_benchmark/benchmark_clair3gpu/summary.txt", comment = "-")) 
deepvarcpu <- read_table("data/HG001_SNV_intersect_benchmark/benchmark_deepvarcpu/summary.txt", comment = "-"))
deepvargpu <- read_table(""data/HG001_SNV_intersect_benchmark/benchmark_deepvargpu/summary.txt", comment = "-"))
freebayes <- read_table("data/HG001_SNV_intersect_benchmark/benchmark_freebayes/summary.txt", comment = "-"))

# Rename columns to fit

colnames(clair3cpu) <- c("threshold",
                         "tp_baseline",
                         "tp_call",
                         "fp",
                         "fn",
                         "precision",
                         "recall",
                         "f1",
                         "caller")
colnames(clair3gpu) <- colnames(clair3cpu)
colnames(deepvarcpu) <- colnames(clair3cpu)
colnames(deepvargpu) <- colnames(clair3cpu)
colnames(freebayes) <- colnames(clair3cpu)

# Double check 

head(clair3cpu)

# Scale up to 100

scale_pr <- function(df){
  df$precision <- df$precision * 100 
  df$recall <- df$recall * 100
  df$f1 <- df$f1 * 100
  return(df)
}

clair3cpu <- scale_pr(clair3cpu)
clair3gpu <- scale_pr(clair3gpu)
deepvarcpu <- scale_pr(deepvarcpu)
deepvargpu <- scale_pr(deepvargpu)
freebayes <- scale_pr(freebayes)

clair3cpu$caller <- "Clair3 CPU"
clair3gpu$caller <- "Clair3 GPU"
deepvarcpu$caller <- "DeepVariant CPU"
deepvargpu$caller <- "DeepVariant GPU"
freebayes$caller <- "FreeBayes"

# Remove rows without threshold 

clair3cpu  <- clair3cpu[clair3cpu$threshold != "None", ]
clair3gpu  <- clair3gpu[clair3gpu$threshold != "None", ]
deepvarcpu <- deepvarcpu[deepvarcpu$threshold != "None", ]
deepvargpu <- deepvargpu[deepvargpu$threshold != "None", ]
freebayes  <- freebayes[freebayes$threshold != "None", ]
benchmark <- rbind(clair3cpu,
                   clair3gpu,
                   deepvarcpu,
                   deepvargpu,
                   freebayes)

# Double check

benchmark[, c("caller","precision","recall","f1")]

benchmark_long <- benchmark %>%
  pivot_longer(cols = c(precision, recall, f1),
               names_to = "metric",
               values_to = "value")

# Set order for callers

benchmark_long$caller <- factor(benchmark_long$caller, 
                                levels = c("Clair3 CPU", "Clair3 GPU", 
                                           "DeepVariant CPU", "DeepVariant GPU", "FreeBayes"))

# Draw barplot

ggplot(benchmark_long, aes(x = caller, y = value, fill = metric)) +
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.8), 
           width = 0.8) +
  geom_text(aes(label = round(value, 2)),
            position = position_dodge(width = 0.8),
            vjust = -0.4, size = 4) +
  scale_fill_manual(values = c("precision" = "#00BA38", 
                               "recall" = "#619CFF", 
                               "f1" = "#F8766D"),
                    labels = c("F1-score", "Precision", "Recall")) +
  labs(x = "Variant caller",
       y = "Score (%)",
       fill = "Metric") +
  theme_classic() +
  theme(
    axis.title = element_text(size = 15),
    axis.text.x = element_text(size = 13, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 13),
    axis.title.x = element_text(size = 15, margin = margin(t = 15)),
    axis.title.y = element_text(size = 15, margin = margin(r = 15)),
    legend.position = "right", 
    legend.title = element_text(size = 15),
    legend.text = element_text(size = 15)
  ) +
  ylim(0, 100)

ggsave("HG001_SNV_benchmark.png",
       width = 14,
       height = 7,
       dpi = 300)
