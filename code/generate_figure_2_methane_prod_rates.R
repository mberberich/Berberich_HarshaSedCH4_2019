### Build Figure 2
### Methane production rates among reservoir zones 
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
ch4_fig <- grid.arrange(
  # methane production rates, normalized by volume
  # statistical significance asterick was added manually
  ggplot(master, aes(zone, umol.CH4.day.cm3)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(Methane~Production~Rates~" ("~µmol~cm^{-3}~d^{-1}~") "),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("A") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20),
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = 2.0, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 2.01, 
             label = " b ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 2.01, 
             label = " b ",parse = TRUE,size=5),
  
  ggplot(master, aes(zone, umol.CH4.day.g.sed)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(Methane~Production~Rates~" ("~µmol~g~sed^{-1}~d^{-1}~") "),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("B") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20),
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = 3.0, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 3.0, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 3.0, 
             label = " a ",parse = TRUE,size=5) ,
  
  ggplot(master, aes(zone, umol.CH4.day.g.om)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(Methane~Production~Rates~" ("~µmol~g~OM^{-1}~d^{-1}~") "),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("C") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_blank(),
          text=element_text(size=12),
          plot.title = element_text(face="bold", hjust = -0.065, size = 20),
          panel.border = element_rect(size = 1, fill = NA)) +
    geom_jitter() +
    annotate('text', x = 1, y = 43, 
             label = " a ",parse = TRUE,size=5) +
    annotate('text', x = 2, y = 43.1, 
             label = " b ",parse = TRUE,size=5) +
    annotate('text', x = 3, y = 43.1, 
             label = " b ",parse = TRUE,size=5) ,
  
  
  nrow = 1, ncol = 3
)

ggsave(file = "results/figures/figure2_ch4_production.pdf", ch4_fig, 
       width=11, height = 4, dpi = 300)

rm(ch4_fig)

