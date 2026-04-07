library(ggplot2)
library(tidyr)
library(dplyr)
library(scales) 

# Input data
data <- read.table("data/annotation_consequences.tsv", 
                   header = TRUE, 
                   sep = "\t")

data_long <- data %>%
  pivot_longer(cols = c(ANNOVAR, SnpEff, VEP),
               names_to = "Tool",
               values_to = "Count") %>%
  filter(Count > 0)

# Visualize 
ggplot(data_long, aes(x = Tool, y = Count, fill = category)) +
  geom_col(position = "stack") + 
  scale_y_log10(
    breaks = trans_breaks("log10", function(x) 10^x),
    labels = trans_format("log10", math_format(10^.x))
  ) +
  labs(
       y = "Count (Log10 scale)",
       fill = "Consequence") +
  theme_classic() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 12),
    legend.position = "right"
  )

ggsave("annotation_consequences_default.png", width = 11, height = 7, dpi = 300)
