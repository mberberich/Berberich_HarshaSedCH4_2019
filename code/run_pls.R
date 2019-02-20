#### PLS - trying this again! ####
#### 

library(openxlsx)
library(ggplot2)
library(ggrepel)
library(plsdepot)
library(dplyr)
source('code/utilities.R')

#### Prepare data ####

master <- read.xlsx("data/process/master_by_sample.xlsx")
pls_extra <- read.xlsx("data/raw/pls_extra_variabes.xlsx")

master_pls <- master %>%
  select("sample.id", "umol.CH4.day.cm3", "om.autoc.proportion", "density.g.ml", "doc.mg.l", "suva254", "fi", "bix", "rfe", "hix", "d15n", "d13c.org", "n.percent", "c.percent.org", "cn", "OM.drywt.percent") 
  
pls_data <-  (left_join(master_pls, pls_extra, by = "sample.id"))

#master_pls_response <- master %>%
#  select("umol.CH4.day.cm3")
#pls2 <- plsreg1(master_cond_pca[ , 1:44], master_cond_pca[ , 45, drop = FALSE], comps = 3)

#### Run PLS ####
harsha_pls <- plsreg1(pls_data[ ,3:47], pls_data[ ,2, drop=FALSE], comps = 3)



#### Plot checks ####

## Plot predicted vs actual
plot(pls_data$umol.CH4.day.cm3, harsha_pls$y.pred)
abline(a = 0, b = 1, col = "gray85", lwd = 2)

## Plot residuals
plot(harsha_pls$resid)




#### Figure ####
#plot(harsha_pls, what = "observations", pos)
sample.info <- read.xlsx("data/raw/sample_information.xlsx") %>%
  rownames_to_column("count")

xscores <- data.frame(harsha_pls$x.scores) %>%
  rownames_to_column("count")

xscores_info <- left_join(xscores, sample.info, by = "count") #%>%
  #unite(id, site.id, core, sep="")

pls_plot <- xscores_info %>%
  ggplot(aes(t1, t2, color = zone)) +
  #geom_point() + 
  geom_text(aes(label=site.id), fontface = "bold", check_overlap = TRUE) +
  theme(panel.background = element_rect(fill = "white"),
        panel.grid.major = element_line(color="gray"),
        panel.grid.minor = element_line(color="gray"),
        text=element_text(size=12),
        plot.title = element_text(face="bold", hjust = -0.065, size = 20),
        panel.border = element_rect(size = 1, fill = NA))

#within geom_text can use check_overlap = TRUE to remove overlapping names

ggsave(file = "results/figures/figure8_pls.pdf", pls_plot, 
       width=9, height = 4, dpi = 300)

#### Supplemental figures and tables ####

## X loads of predictor variables
xloads <- data.frame(harsha_pls$x.loads[, 1:2]) %>%
  rownames_to_column() 
write.xlsx(xloads, "results/tables/tableS2_PLS_xloads.xlsx")

## Y scores
yscores <- data.frame(harsha_pls$y.scores[, 1:2]) %>%
  rownames_to_column()
write.xlsx(yscores, "results/tables/tableS3_PLS_yscores.xlsx")

## Y loads
yloads <- harsha_pls$y.loads
write.xlsx(yloads, "results/tables/tableS4_PLS_yloads.xlsx")

## R2Xy
r2xy <- harsha_pls$R2Xy[, 1:2]
write.xlsx(r2xy, "results/tables/tableS5_PLS_r2xy.xlsx")


## Circle of correlations figure

plot(harsha_pls)
dev.copy(pdf, "results/figures/figureS1_PLS_circle_correlations.pdf")
dev.off()

#ggsave(file = "results/figures/figureS1_PLS_circle_correlations.pdf", circ, 
#       width=7.3, height = 4, dpi = 300)
#       
rm(list = c('master_pls', 'pls_data', 'pls_extra', 'r2xy', 'sample.info', 'xloads', 'xscores', 'xscores_info', 'yscores', 'harsha_pls', 'pls_plot', 'yloads'))
