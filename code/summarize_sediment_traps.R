#### Sediment trap data summary ####
### Megan Berberich 
### HarshaSedCH4_LimnolOcean_2018 


source('code/utilities.R')

trap <- read.xlsx("data/raw/sediment_traps_summary.xlsx")

trap_calculations <- trap %>%
  mutate(sed.rate.mg.l.day=particulate.conc.mg.l/days.elapsed) %>%
  # the volume of the sediment trap was 520 mL and the area of the top was 19.63 cm2
  mutate(sed.rate.mg.cm2.day = sed.rate.mg.l.day*(520/1000)/19.63) %>%
  # multiply by 10000 to go from cm2 to m2 and divide by 1000 to go from mg to g
  mutate(sed.rate.g.m2.day = sed.rate.mg.cm2.day*10000/1000) %>% 
  mutate(chl.depositon.rate.mg.m2.day = (((chlA.ug.L/1000)/days.elapsed)*(520/1000)/19.63)*10000) %>%
  mutate(om.sed.rate.g.m2.day = sed.rate.g.m2.day * (om.percent/100))


trap_filtered_EUS <- trap_calculations %>%
  filter(site.name=="EUS") %>%
  group_by(date.deployed) %>%
  summarize(mean.particulate = mean(particulate.conc.mg.l), mean.om.percent=mean(om.percent), mean.om.conc.mg.l=mean(om.conc.mg.l), d13c.org=mean(d13c.org, na.rm=TRUE), d15n=mean(d15n, na.rm=TRUE), mean.chlA=mean(chlA.ug.L, na.rm=TRUE), mean.sed.rate.g.m2.day=mean(sed.rate.g.m2.day), mean.chl.deposition.rate.mg.m2.day=mean(chl.depositon.rate.mg.m2.day, na.rm=TRUE), c.percent.org=mean(c.percent.org, na.rm=TRUE), n.percent=mean(n.percent, na.rm=TRUE), om.sed.rate.g.m2.day=mean(om.sed.rate.g.m2.day, na.rm=TRUE)) %>%
  mutate(cn=c.percent.org/n.percent) %>%
  mutate(nc=n.percent/c.percent.org)

trap_EUS_summary <- trap_filtered_EUS %>%
  summarize(mean.particulate.conc.mg.l = mean(mean.particulate, na.rm=TRUE), mean.om.percent=mean(mean.om.percent, na.rm=TRUE), mean.om.conc.mg.l=mean(mean.om.conc.mg.l, na.rm=TRUE), d13c.org=mean(d13c.org, na.rm=TRUE), d15n=mean(d15n, na.rm=TRUE), mean.chlA.ug.L=mean(mean.chlA, na.rm=TRUE), mean.sed.rate.g.m2.day=mean(mean.sed.rate.g.m2.day, na.rm=TRUE), mean.chl.deposition.rate.mg.m2.day=mean(mean.chl.deposition.rate.mg.m2.day, na.rm=TRUE), c.percent.org=mean(c.percent.org, na.rm=TRUE), n.percent=mean(n.percent, na.rm=TRUE), cn=mean(cn, na.rm=TRUE), nc=mean(nc, na.rm=TRUE), om.sed.rate.g.m2.day=mean(om.sed.rate.g.m2.day, na.rm=TRUE))

trap_filtered_ENN <- trap_calculations %>%
  filter(site.name=="ENN") %>%
  group_by(date.deployed) %>%
  summarize(mean.particulate = mean(particulate.conc.mg.l), mean.om.percent=mean(om.percent), mean.om.conc.mg.l=mean(om.conc.mg.l), d13c.org=mean(d13c.org, na.rm=TRUE), d15n=mean(d15n, na.rm=TRUE), mean.chlA=mean(chlA.ug.L, na.rm=TRUE), mean.sed.rate.g.m2.day=mean(sed.rate.g.m2.day), mean.chl.deposition.rate.mg.m2.day=mean(chl.depositon.rate.mg.m2.day, na.rm=TRUE), c.percent.org=mean(c.percent.org, na.rm=TRUE), n.percent=mean(n.percent, na.rm=TRUE), om.sed.rate.g.m2.day=mean(om.sed.rate.g.m2.day, na.rm=TRUE)) %>%
  mutate(cn=c.percent.org/n.percent) %>%
  mutate(nc=n.percent/c.percent.org)

trap_ENN_summary <- trap_filtered_ENN %>%
  summarize(mean.particulate.conc.mg.l = mean(mean.particulate, na.rm=TRUE), mean.om.percent=mean(mean.om.percent, na.rm=TRUE), mean.om.conc.mg.l=mean(mean.om.conc.mg.l, na.rm=TRUE), d13c.org=mean(d13c.org, na.rm=TRUE), d15n=mean(d15n, na.rm=TRUE), mean.chlA.ug.L=mean(mean.chlA, na.rm=TRUE), mean.sed.rate.g.m2.day=mean(mean.sed.rate.g.m2.day, na.rm=TRUE), mean.chl.deposition.rate.mg.m2.day=mean(mean.chl.deposition.rate.mg.m2.day, na.rm=TRUE), c.percent.org=mean(c.percent.org, na.rm=TRUE), n.percent=mean(n.percent, na.rm=TRUE), cn=mean(cn, na.rm=TRUE), nc=mean(nc, na.rm=TRUE), om.sed.rate.g.m2.day=mean(om.sed.rate.g.m2.day, na.rm=TRUE))

trap_filtered_EFL <- trap_calculations %>%
  filter(site.name=="EFL") %>%
  group_by(date.deployed) %>%
  summarize(mean.particulate = mean(particulate.conc.mg.l), mean.om.percent=mean(om.percent), mean.om.conc.mg.l=mean(om.conc.mg.l), d13c.org=mean(d13c.org, na.rm=TRUE), d15n=mean(d15n, na.rm=TRUE), mean.chlA=mean(chlA.ug.L, na.rm=TRUE), mean.sed.rate.g.m2.day=mean(sed.rate.g.m2.day), mean.chl.deposition.rate.mg.m2.day=mean(chl.depositon.rate.mg.m2.day, na.rm=TRUE), c.percent.org=mean(c.percent.org, na.rm=TRUE), n.percent=mean(n.percent, na.rm=TRUE), om.sed.rate.g.m2.day=mean(om.sed.rate.g.m2.day, na.rm=TRUE)) %>%
  mutate(cn=c.percent.org/n.percent) %>%
  mutate(nc=n.percent/c.percent.org)

trap_EFL_summary <- trap_filtered_EFL %>%
  summarize(mean.particulate.conc.mg.l = mean(mean.particulate, na.rm=TRUE), mean.om.percent=mean(mean.om.percent, na.rm=TRUE), mean.om.conc.mg.l=mean(mean.om.conc.mg.l, na.rm=TRUE), d13c.org=mean(d13c.org, na.rm=TRUE), d15n=mean(d15n, na.rm=TRUE), mean.chlA.ug.L=mean(mean.chlA, na.rm=TRUE), mean.sed.rate.g.m2.day=mean(mean.sed.rate.g.m2.day, na.rm=TRUE), mean.chl.deposition.rate.mg.m2.day=mean(mean.chl.deposition.rate.mg.m2.day, na.rm=TRUE), c.percent.org=mean(c.percent.org, na.rm=TRUE), n.percent=mean(n.percent, na.rm=TRUE), cn=mean(cn, na.rm=TRUE), nc=mean(nc, na.rm=TRUE), om.sed.rate.g.m2.day=mean(om.sed.rate.g.m2.day, na.rm=TRUE))


