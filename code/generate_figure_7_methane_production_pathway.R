### Build Figure 7
### Methane production pathway
### Megan Berberich, University of Cincinnati

## load packages
library(dplyr)
library(ggplot2)
library(openxlsx)
library(gridExtra)

## load data
master <- read.xlsx("data/process/master_by_sample.xlsx")



pathway_graph <- grid.arrange(
  # g OM per cubic cm of sediment
  ggplot(master, aes(zone, d13c.ch4)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(~delta^{13}*C~CH[4]~""),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("A") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20), 
          panel.border = element_rect(size = 1, fill = NA)) +
    annotate('text', x = 1, y = -46, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = -46, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = -46, 
             label = " a ",parse = TRUE,size=5) + 
    geom_jitter(),
  
  ggplot(master, aes(zone, fractionation.factor)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    geom_hline(yintercept = 1.05, colour = "blue") +
    labs(y=expression(Apparent~fractionation~factor~" ("~alpha[C]~") "),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("B") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20), 
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = 1.052, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 1.052, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 1.052, 
             label = " a ",parse = TRUE,size=5),
  
  nrow = 1, ncol = 2
)

ggsave(file = "results/figures/figure7_methane_production_pathway.pdf", pathway_graph, 
       width=7.3, height = 4, dpi = 300)

rm(pathway_graph)
