# Open required packages
source('code/utilities.R')
library(lme4)
library(lmerTest)

#### DATA ####
master <- read.xlsx("data/process/master_by_sample.xlsx")


#### Site characteristics ####

# Testing for differences in isotopic and elemental coposition of epilimnion water samples from May.

mm_aquatic <- read.xlsx("data/other/test/mixing_model_aquatic_source.xlsx")

summary(aov(mm_aquatic$d13C ~ mm_aquatic$zone))
summary(aov(mm_aquatic$d15N ~ mm_aquatic$zone))
summary(aov(mm_aquatic$CN.ratio ~ mm_aquatic$zone))
summary(aov(mm_aquatic$NC.ratio ~ mm_aquatic$zone))

#tapply(mm_aquatic$d13C, mm_aquatic$zone, var)
#tapply(mm_aquatic$d15N, mm_aquatic$zone, var)
#tapply(mm_aquatic$CN.ratio, mm_aquatic$zone, var)
#model1<-aov(mm_aquatic$d13C ~ mm_aquatic$zone)
#TukeyHSD(model1)
#model2<-aov(mm_aquatic$d15N ~ mm_aquatic$zone)
#TukeyHSD(model2)
#model3<-aov(mm_aquatic$CN.ratio ~ mm_aquatic$zone)
#TukeyHSD(model3)
#rm(model1)
#rm(model2)
#rm(model3)

rm(mm_aquatic)



#### Methane potential production rates among reservoir zones ####
ch4.cm3 <- memod(master$umol.CH4.day.cm3, master$zone, master$site.name)
ch4.g.om <- memod(master$umol.CH4.day.g.om, master$zone, master$site.name)
ch4.cm2 <- memod(master$umol.CH4.day.cm2, master$zone, master$site.name)
ch4.g.sed <- memod(master$umol.CH4.day.g.sed, master$zone, master$site.name)

ch4.areal.summary <- master %>%
  summarize(ave.ch4.areal=mean(umol.CH4.day.cm2), 
            min.ch4.areal=min(umol.CH4.day.cm2), 
            max.ch4.areal=max(umol.CH4.day.cm2)) 

rm(list = c('ch4.cm3', 'ch4.g.om', 'ch4.cm2', 'ch4.g.sed', 'ch4.areal.summary'))


#### Sediment characteristics among reservoir zones ####

## Density
density.summary <- master %>%
  group_by(zone) %>%
  summarize(ave.density=mean(density.g.ml))
density <- memod(master$density.g.ml, master$zone, master$site.name)

## DOC
## Note that the stats presented in the paper are log-transformed. 
## IF DOING STATS ON LOG-TRANSFORMED DOC
doc.log <- master %>%
  dplyr::select(zone, site.name, doc.mg.l) %>%
  mutate(logDOC = log(doc.mg.l)) 
doc <- memod(doc.log$logDOC, master$zone, master$site.name)
## IF DOING STATS ON RAW DOC VALUES
#doc <- memod(master$doc.mg.l, master$zone, master$site.name)
 
## OM quantity and source
om <- memod(master$g.om.per.cm3, master$zone, master$site.name)
om.source <- memod(master$om.autoc.proportion, master$zone, master$site.name)

## Elemental ratios of sediment
cn.summary.zone <- master %>%
  group_by(zone) %>%
  summarize(cn.zone.mean=mean(cn))
cn.summary.site <- master %>%
  group_by(site.id) %>%
  summarize(cn.site.mean=mean(cn)) 

## DOM optical properties
fi <- memod(master$fi, master$zone, master$site.name)
bix <- memod(master$bix, master$zone, master$site.name)
bix.summary.site <- master %>%
  group_by(site.name) %>%
  summarize(bix.site.mean=mean(bix)) %>%
  summarize(bix.site.min=min(bix.site.mean),
            bix.site.max=max(bix.site.mean))
bix.summary.zone <- master %>%
  group_by(zone) %>%
  summarize(bix.zone.mean=mean(bix),
            bix.zone.median=median(bix)) 
hix <- memod(master$hix, master$zone, master$site.name) 
hix.summary.site <- master %>%
  group_by(site.id) %>%
  summarize(hix.site.mean=mean(hix)) 
hix.summary.zone <- master %>%
  group_by(zone) %>%
  summarize(hix.zone.mean=mean(hix),
            hix.zone.median=median(hix))
suva <- memod(master$suva254, master$zone, master$site.name)
suva.summary.zone <- master %>%
  group_by(zone) %>%
  summarize(suva.zone.mean=mean(suva254),
            suva.zone.median=median(suva254))
suva.summary.site <- master %>%
  group_by(site.id) %>%
  summarize(suva.site.mean=mean(suva254))

rm(list = c('suva', 'hix', 'bix', 'fi', 'suva.summary.zone', 'hix.summary.zone', 'bix.summary.zone', 'bix.summary.site', 'cn.summary.zone', 'cn.summary.site', 'om', 'om.source', 'doc', 'doc.log', 'density', 'density.summary'))

#### Sediment deposition rates and deposited sediment composition ####
#### STILL NEEDS WORK


#### Methanogen communities among reservoir zones ####

# Create intermediate df of mcra to omit NAs and log transform copies mcrA per ng DNA per g sed
mcra <- master %>%
  dplyr::select(sample.id, zone, site.name, mcra.ng.g.sed) %>%
  na.omit(mcra.ng.g.sed) %>%
  mutate(log.mcra = log(mcra.ng.g.sed))
# Run memod on log transformed mcra
mcra.memod <- memod(mcra$log.mcra, mcra$zone, mcra$site.name)

# Create intermediate df of arc to omit NAs and log transform copies arc per ng DNA per g sed
arc <- master %>%
  dplyr::select(sample.id, zone, site.name, arc.ng.g.sed) %>%
  na.omit(arc.ng.g.sed) %>%
  mutate(log.arc = log(arc.ng.g.sed))
# Run memod on log transformed arc
arc.memod <- memod(arc$log.arc, arc$zone, arc$site.name)


mcra.summary <- mcra %>%
  summarize(mcra.mean=mean(mcra.ng.g.sed),
            mcra.min=min(mcra.ng.g.sed),
            mcra.max=max(mcra.ng.g.sed))


rm(list = c('arc', 'arc.memod', 'mcra', 'mcra.memod', 'mcra.summary'))

#### Methane production pathway ####

gasiso <- master %>%
  dplyr::select(sample.id, zone, site.name, d13c.ch4, d13c.co2, fractionation.factor) %>%
  na.omit(arc.ng.g.sed)

gasiso.summary <- gasiso %>%
  summarize(d13c.ch4.min=min(d13c.ch4),
            d13c.ch4.max=max(d13c.ch4),
            d13c.ch4.mean=mean(d13c.ch4),
            d13c.co2.mean=mean(d13c.co2),
            frac.min=min(fractionation.factor),
            frac.max=max(fractionation.factor))

gasiso.memod <- memod(gasiso$d13c.ch4, gasiso$zone, gasiso$site.name)

rm(list = c('gasiso', 'gasiso.summary', 'gasiso.memod'))


#### Influence of OM source and quantity on CH4 production rates ####
#### STILL NEED TO RERUN AND VERIFY


#### Contextual parameters that explain spatial variation in CH4 production rates ####
#### STILL NEED TO RERUN AND VERIFY


#### DISCUSSION ####


#### Spatial variability of spatial measurements across the reservoir ####

# Comparison of riverine with Jake's emission values
ch4.mg.areal.zone <- master %>%
  group_by(zone) %>%
  summarize(mg.ch4.m2.hr = mean(mg.CH4.m2.hour))

# Comparison of production with other freshwater
ch4.conversions <- master %>%
  dplyr::select(sample.id, zone, umol.CH4.day.g.sed) %>%
  mutate(nmol.ch4.g.sed.hr=((umol.CH4.day.g.sed*1000)/24)) %>%
  summarize(nmol.ch4.g.sed.hr.mean=mean(nmol.ch4.g.sed.hr),
            nmol.ch4.g.sed.hr.min=min(nmol.ch4.g.sed.hr),
            nmol.ch4.g.sed.hr.max=max(nmol.ch4.g.sed.hr))



# Density
sed.density.zone <- master %>%
  dplyr::select(sample.id, zone, density.g.ml) %>%
  group_by(zone) %>%
  summarize(density.avg=mean(density.g.ml)) %>%
  mutate(percent.from.lac=((1.454914-density.avg)/density.avg)*100)
  

test <- master %>%
  dplyr::select(sample.id, zone, d13c.org, cn, d13c.ch4) %>%
  na.omit() %>%
  mutate(d13c.diff=(d13c.org-d13c.ch4)) %>%
  summary(lm(d13c.diff ~ cn))


test.lm <- lm(test$cn ~ test$d13c.diff)

summary(test.lm)



#### EXTRA/MISC ####

summary(lm(master$umol.CH4.day.cm3 ~ master$hix))
plot(master$umol.CH4.day.cm3 ~ master$hix)

summary(lm(master$umol.CH4.day.cm3 ~ master$suva254))
plot(master$umol.CH4.day.cm3 ~ master$suva254)

summary(lm(master$umol.CH4.day.cm3 ~ master$bix))
plot(master$umol.CH4.day.cm3 ~ master$bix)

summary(lm(master$umol.CH4.day.cm3 ~ master$cn))
plot(master$umol.CH4.day.cm3 ~ master$cn)

summary(lm(master$umol.CH4.day.cm3 ~ master$c.percent.org))
plot(master$umol.CH4.day.cm3 ~ master$c.percent.org)

summary(lm(master$umol.CH4.day.cm3 ~ master$slurry.om.drywt.g))
plot(master$umol.CH4.day.cm3 ~ master$slurry.om.drywt.g)

ggplot(mcra, aes(zone, mcra.ng.g.sed)) +
  geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
  labs(y=expression(mcra),
       x=expression("")) +
  scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) +
  theme(panel.background = element_rect(fill = "white"),
        panel.grid.major = element_blank(),
        text=element_text(size=12),
        plot.title = element_text(face="bold", hjust = -0.065, size = 20),
        panel.border = element_rect(size = 1, fill = NA)) +
  geom_jitter()


cn <- memod(master$cn, master$zone, master$site.name)
c.org <- memod(master$c.percent.org, master$zone, master$site.name)
n <- memod(master$n.percent, master$zone, master$site.name)
n.iso <- memod(master$d15n, master$zone, master$site.name)
c.iso.org <- memod(master$d13c.org, master$zone, master$site.name)
om <- memod(master$OM.drywt.percent, master$zone, master$site.name)

fresh <- memod(master$freshness.index, master$zone, master$site.name)
suva <- memod(master$suva254, master$zone, master$site.name)
rfe <- memod(master$rfe, master$zone, master$site.name)
acetate <- memod(master$acetic.acid.mg.l, master$zone, master$site.name)

combined <- data.frame(rbind(
  ch4,
  autoc))