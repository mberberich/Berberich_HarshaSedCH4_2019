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

biplot<-readPNG("results/pictures/mixing_model_biplot.png")
#biplot.raster <- as.raster(biplot)
#rasterImage(biplot.raster, xleft = 1, xright = 1, ybottom = 2, ytop = 1)

#plot(NA,xlim=c(0,nrow(biplot.raster)),ylim=c(0,ncol(biplot.raster)))
#rasterImage(biplot.raster,300,300,nrow(biplot.raster),ncol(biplot.raster))
#fig6.a <- grob(plot)
#plot <- grid.raster(biplot.raster)

#plotRGB(biplot.raster)
## load data
## 
grob1<- rasterGrob(biplot, height = unit(1, "npc"), width = unit(1, "npc"))

master <- read.xlsx("data/process/master_by_sample.xlsx")


### make empty ggplot
### 
dat <- data.frame(x=runif(0),y=runif(0))

p <- ggplot(dat, aes(x=x, y=y)) + 
  geom_point() +
  scale_x_continuous(expand=c(0,0)) + 
  scale_y_continuous(expand=c(0,0))   

p1 <- p + theme(axis.line=element_blank(),axis.text.x=element_blank(),
          axis.text.y=element_blank(),axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),legend.position="none",
          panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),plot.background=element_blank()) +
  geom_blank()


#p1 + ggtitle("A") + theme(plot.title = element_text(face="bold", size = 20)) + annotation_custom(grob = grob1) 
# make plot of proportion of autochthonous OM

om_autoc_graph <- grid.arrange(
  
  p1 + ggtitle("A") + theme(plot.title = element_text(face="bold", hjust = 0.12, size = 20)) + annotation_custom(grob = grob1) ,
  
  ggplot(master, aes(zone, om.autoc.proportion)) +
    geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
    labs(y=expression(Proportion~of~autochthonous~OM~""),
         x=expression("")) +
    scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("B") +
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
       width=7.3, height = 4, dpi = 300)

rm(om_autoc_graph)
rm(biplot)
rm(grob1)
rm(p)
rm(p1)
rm(dat)
