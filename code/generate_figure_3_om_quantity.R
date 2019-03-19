### Build Figure 3 
### Quantity of OM among reservoir zones 
### Megan Berberich, University of Cincinnati

## load packages
library(dplyr)
library(ggplot2)
library(openxlsx)
library(gridExtra)

## load data
master <- read.xlsx("data/process/master_by_sample.xlsx")

# make plot of g OM per cubic cm of sediment and of DOC (eliminate the highest value)

# subset data so that the one crazy DOC point is removed
DOC_sub <- subset(master, doc.mg.l < 300)

om_quantity_graph <- grid.arrange(
  # g OM per cubic cm of sediment
  ggplot(master, aes(zone, g.om.per.cm3)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(g~OM~cm^{-3}~""),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("A") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20), 
          panel.border = element_rect(size = 1, fill = NA)) +
    annotate('text', x = 1, y = 0.061, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 0.061, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 0.061, 
             label = " a ",parse = TRUE,size=5) + 
    geom_jitter(),
  
  ggplot(DOC_sub, aes(zone, doc.mg.l)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(DOC~" ("~mg~L^{-1}~") "),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("B") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20), 
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = 54, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 54, 
             label = " b ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 54, 
             label = " b ",parse = TRUE,size=5),
  
  nrow = 1, ncol = 2
)

ggsave(file = "results/figures/figure3_sediment_om_quantity.pdf", om_quantity_graph, 
       width=7.3, height = 4, dpi = 1200)

rm(DOC_sub)
rm(om_quantity_graph)



