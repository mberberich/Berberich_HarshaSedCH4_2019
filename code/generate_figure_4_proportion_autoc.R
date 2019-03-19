### Build Figure 4 
### Proportion of autocthonous OM among reservoir zones 
### Megan Berberich, University of Cincinnati

## load packages
library(dplyr)
library(ggplot2)
library(openxlsx)
library(gridExtra)
library(png)
library(grid)

master <- read.xlsx("data/process/master_by_sample.xlsx")
em_iso <- read.xlsx("data/process/mixing_model/end_member_isotopes.xlsx")

em_iso_summary <- em_iso %>%
  group_by(Source) %>%
  summarize(sd15n = sd(d15N),
            sdNC = sd(NC),
            mean15n = mean(d15N),
            meanNC = mean(NC))



om_autoc_graph <- grid.arrange(
  
  ggplot() +
    geom_point(data = em_iso_summary, aes(x = meanNC, y = mean15n)) +
    geom_text(data = em_iso_summary, aes(x = meanNC, y = mean15n, label = Source), hjust = 0, nudge_x = 0.03) +
    geom_errorbar(data = em_iso_summary, aes(x = meanNC, ymin = mean15n + sd15n, ymax = mean15n - sd15n), width = 0.004) +
    geom_errorbarh(data = em_iso_summary, aes(y = mean15n, xmin = meanNC + sdNC, xmax = meanNC - sdNC, height = 0.2)) +
    geom_point(data = master, aes(x = nc, y = d15n, color = zone)) +
    xlim(0, 0.25) +
    ylim(0, 12.5) +
    ggtitle("A") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_line(color = "grey90"),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20), 
          panel.border = element_rect(size = 1, fill = NA)) +
    labs(y=expression(delta^15~N),
         x=expression("N:C"))
  ,
  
  ggplot(master, aes(zone, om.autoc.proportion)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(Proportion~of~autochthonous~OM~""),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + 
    ggtitle("B") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20), 
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = .61, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = .61, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = .61, 
             label = " b ",parse = TRUE,size=5),
  
  nrow = 1, ncol = 2
)

ggsave(file = "results/figures/figure4_proportion_autoc_om.pdf", om_autoc_graph, 
       width=8.4, height = 4, dpi = 1200)

rm(om_autoc_graph)
rm(em_iso)
rm(em_iso_summary)
rm(master)
