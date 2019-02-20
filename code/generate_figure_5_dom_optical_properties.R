### Build Figure 5 
### OM source in DOM (optical properties) 
### Megan Berberich, University of Cincinnati

## load packages
library(dplyr)
library(ggplot2)
library(openxlsx)
library(gridExtra)

## load data
master <- read.xlsx("data/process/master_by_sample.xlsx")

#slurry_dry_wt <- read.xlsx("data/raw/slurry_dry_wt_final_pressure.xlsx")
#organic_matter <- read.xlsx("data/raw/LOI.xlsx")

## calculations on data
# calculate methane production rates in umol CH4 g dry sediment^-1 day^-1
#ch4$umol_CH4_day_g_sed <- (ch4$umol_CH4_day / slurry_dry_wt$slurry.dry.wt.g[1:46])
# calculate methane production rates in umol CH4 g OM^-1 day^-1
#ch4$umol_CH4_day_g_OM <- (ch4$umol_CH4_day / (slurry_dry_wt$slurry.dry.wt.g[1:46] * organic_matter$OM.drywt.percent[1:46]))

## plot boxplots of CH4 production rates
om_source_dissolved <- grid.arrange(
  # methane production rates, normalized by volume
  # statistical significance asterick was added manually
  ggplot(master, aes(zone, fi)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(FI~" ("~fluorescence~index~") "),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("A") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20),
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = 1.81, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 1.8097, 
             label = " b ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 1.8097, 
             label = " b ",parse = TRUE,size=5),
  
  ggplot(master, aes(zone, bix)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(BIX~" ("~biological~index~") "),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("B") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20),
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = 0.797, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 0.797, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 0.797, 
             label = " a ",parse = TRUE,size=5) ,
  
  ggplot(master, aes(zone, hix)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(HIX~" ("~humification~index~") "),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("C") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20),
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = 1.01, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 1.0097, 
             label = " b ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 1.0097, 
             label = " b ",parse = TRUE,size=5),
  
  ggplot(master, aes(zone, suva254)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(SUVA[254]~" ("~mg~C^{-1}~m^{-1}~") "),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("D") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20),
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = 9.797, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 9.797, 
             label = " b ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 9.797, 
             label = " c ",parse = TRUE,size=5) ,
  
  nrow = 2, ncol = 2
)

ggsave(file = "results/figures/figure5_dissolved_om_optical.pdf", om_source_dissolved, 
       width=7.3, height = 6, dpi = 300)

rm(om_source_dissolved)
