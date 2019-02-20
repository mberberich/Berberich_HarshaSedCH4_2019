#### Generate tables ####
#### Note that tables 1 and 5 are manually generated.

source('code/utilities.R')
library(htmlTable)


#### Table 1: Site properties ####
# Manually made.




#### Table 2: Bulk sediment ####
master <- read.xlsx("data/process/master_by_sample.xlsx")
site_df <- read.xlsx("data/raw/site_information.xlsx")

tab2_sed <- master %>%
  select(site.id, 
         zone, 
         umol.CH4.day.cm3, 
         c.percent.org, 
         d13c.org, 
         n.percent, 
         d15n, 
         cn, 
         OM.drywt.percent, 
         density.g.ml, 
         om.autoc.proportion) %>%
  group_by(site.id) %>%
  summarize_if(is.numeric, funs(mean, sd)) %>%
  separate(site.id, c("z", "number"), sep=1) %>%
  mutate(zone = if_else(z =="L", "lacustrine", if_else(z == "T", "transitional", "riverine"))) %>%
  unite(site.id, c("z", "number"), sep="") %>%
  mutate_if(is.numeric, funs(round(.,2))) %>%
  unite("CH4 production rates", c("umol.CH4.day.cm3_mean", "umol.CH4.day.cm3_sd"), sep = " +/- ") %>%
  unite("%Corg", c("c.percent.org_mean", "c.percent.org_sd"), sep = " +/- ") %>%
  unite("d13Corg", c("d13c.org_mean", "d13c.org_sd"), sep = " +/- ") %>%
  unite("%N", c("n.percent_mean", "n.percent_sd"), sep = " +/- ") %>%
  unite("d15N", c("d15n_mean", "d15n_sd"), sep = " +/- ") %>%
  unite("C:N", c("cn_mean", "cn_sd"), sep = " +/- ") %>%
  unite("OM percent", c("OM.drywt.percent_mean", "OM.drywt.percent_sd"), sep = " +/- ") %>%
  unite("Density", c("density.g.ml_mean", "density.g.ml_sd"), sep = " +/- ") %>%
  unite("Proportion autochthonous OM", c("om.autoc.proportion_mean", "om.autoc.proportion_sd"), sep = " +/- ") %>%
  arrange(match(zone, c("riverine", "transitional", "lacustrine"))) %>%
  select("Site" = site.id, "Reservoir Zone" = zone, "CH4 production rates":"Proportion autochthonous OM")


tab2_sed_zone <- master %>%
  select(site.id, 
         zone, 
         umol.CH4.day.cm3, 
         c.percent.org, 
         d13c.org, 
         n.percent, 
         d15n, 
         cn, 
         OM.drywt.percent, 
         density.g.ml, 
         om.autoc.proportion) %>%
  group_by(zone) %>%
  summarize_if(is.numeric, funs(mean, sd)) %>%
  mutate(site.id = if_else(zone =="lacustrine", "L", if_else(zone == "transitional", "T", "R"))) %>%
  mutate_if(is.numeric, funs(round(.,2))) %>%
  unite("CH4 production rates", c("umol.CH4.day.cm3_mean", "umol.CH4.day.cm3_sd"), sep = " +/- ") %>%
  unite("%Corg", c("c.percent.org_mean", "c.percent.org_sd"), sep = " +/- ") %>%
  unite("d13Corg", c("d13c.org_mean", "d13c.org_sd"), sep = " +/- ") %>%
  unite("%N", c("n.percent_mean", "n.percent_sd"), sep = " +/- ") %>%
  unite("d15N", c("d15n_mean", "d15n_sd"), sep = " +/- ") %>%
  unite("C:N", c("cn_mean", "cn_sd"), sep = " +/- ") %>%
  unite("OM percent", c("OM.drywt.percent_mean", "OM.drywt.percent_sd"), sep = " +/- ") %>%
  unite("Density", c("density.g.ml_mean", "density.g.ml_sd"), sep = " +/- ") %>%
  unite("Proportion autochthonous OM", c("om.autoc.proportion_mean", "om.autoc.proportion_sd"), sep = " +/- ") %>%
  arrange(match(zone, c("riverine", "transitional", "lacustrine"))) %>%
  select("Site" = site.id, "Reservoir Zone" = zone, "CH4 production rates":"Proportion autochthonous OM")

table2_sediment <- bind_rows(tab2_sed, tab2_sed_zone) #%>% 
  #remove_rownames() %>%
  #column_to_rownames(var="Site") 

#mutate_at(vars(umol.CH4.day.cm3_mean, c.percent.org_mean, d13c.org_mean, d15n_mean, cn_mean, OM.drywt.percent_mean, density.g.ml_mean), funs(round(.,2)))
  

## Optional code for generating an html table
#sed_table <- htmlTable(table2_sed,
#                      caption="Table 2.",
#                      width="500px", 
#                      height="20px")
#htmlTableWidget(sed_table)      

write.xlsx(table2_sediment, "results/tables/table2_sediment_characteristics.xlsx")
rm(master)
rm(site_df)
rm(tab2_sed)
rm(tab2_sed_zone)
rm(table2_sediment)




#### Table 3: Sediment porewater ####

master <- read.xlsx("data/process/master_by_sample.xlsx")
site_df <- read.xlsx("data/raw/site_information.xlsx")

tab3_porewater <- master %>%
  select(site.id, 
         zone, 
         doc.mg.l, 
         fi, 
         bix, 
         rfe, 
         hix, 
         suva254) %>%
  group_by(site.id) %>%
  summarize_if(is.numeric, funs(mean, sd)) %>%
  separate(site.id, c("z", "number"), sep=1) %>%
  mutate(zone = if_else(z =="L", "lacustrine", if_else(z == "T", "transitional", "riverine"))) %>%
  unite(site.id, c("z", "number"), sep="") %>%
  mutate_if(is.numeric, funs(round(.,2))) %>%
  unite("DOC", c("doc.mg.l_mean", "doc.mg.l_sd"), sep = " +/- ") %>%
  unite("FI", c("fi_mean", "fi_sd"), sep = " +/- ") %>%
  unite("BIX", c("bix_mean", "bix_sd"), sep = " +/- ") %>%
  unite("RFE", c("rfe_mean", "rfe_sd"), sep = " +/- ") %>%
  unite("HIX", c("hix_mean", "hix_sd"), sep = " +/- ") %>%
  unite("SUVA254", c("suva254_mean", "suva254_sd"), sep = " +/- ") %>%
  arrange(match(zone, c("riverine", "transitional", "lacustrine"))) %>%
  select("Site" = site.id, "Reservoir Zone" = zone, "DOC":"SUVA254")


tab3_porewater_zone <- master %>%
  select(site.id, 
         zone, 
         doc.mg.l, 
         fi, 
         bix, 
         rfe, 
         hix, 
         suva254) %>%
  group_by(zone) %>%
  summarize_if(is.numeric, funs(mean, sd)) %>%
  mutate(site.id = if_else(zone =="lacustrine", "L", if_else(zone == "transitional", "T", "R"))) %>%
  mutate_if(is.numeric, funs(round(.,2))) %>%
  unite("DOC", c("doc.mg.l_mean", "doc.mg.l_sd"), sep = " +/- ") %>%
  unite("FI", c("fi_mean", "fi_sd"), sep = " +/- ") %>%
  unite("BIX", c("bix_mean", "bix_sd"), sep = " +/- ") %>%
  unite("RFE", c("rfe_mean", "rfe_sd"), sep = " +/- ") %>%
  unite("HIX", c("hix_mean", "hix_sd"), sep = " +/- ") %>%
  unite("SUVA254", c("suva254_mean", "suva254_sd"), sep = " +/- ") %>%
  arrange(match(zone, c("riverine", "transitional", "lacustrine"))) %>%
  select("Site" = site.id, "Reservoir Zone" = zone, "DOC":"SUVA254")

table3_porewater <- bind_rows(tab3_porewater, tab3_porewater_zone) #%>% 
#remove_rownames() %>%
#column_to_rownames(var="Site") 

#mutate_at(vars(umol.CH4.day.cm3_mean, c.percent.org_mean, d13c.org_mean, d15n_mean, cn_mean, OM.drywt.percent_mean, density.g.ml_mean), funs(round(.,2)))


## Optional code for generating an html table
#sed_table <- htmlTable(table2_sed,
#                      caption="Table 2.",
#                      width="500px", 
#                      height="20px")
#htmlTableWidget(sed_table)      

write.xlsx(table3_porewater, "results/tables/table3_porewater_characteristics.xlsx")
rm(master)
rm(site_df)
rm(tab3_porewater)
rm(tab3_porewater_zone)
rm(table3_porewater)




#### Table 4: Sediment traps ####
trap <- read.xlsx("data/raw/sediment_traps_summary.xlsx")

trap_calculations <- trap %>%
  mutate(sed.rate.mg.l.day=particulate.conc.mg.l/days.elapsed) %>%
  # the volume of the sediment trap was 520 mL and the area of the top was 19.63 cm2
  mutate(sed.rate.mg.cm2.day = sed.rate.mg.l.day*(520/1000)/19.63) %>%
  # multiply by 10000 to go from cm2 to m2 and divide by 1000 to go from mg to g
  mutate(sed.rate.g.m2.day = sed.rate.mg.cm2.day*10000/1000) %>% 
  mutate(chl.depositon.rate.mg.m2.day = (((chlA.ug.L/1000)/days.elapsed)*(520/1000)/19.63)*10000) %>%
  mutate(om.sed.rate.g.m2.day = sed.rate.g.m2.day * (om.percent/100))

trap_filtered <- trap_calculations %>%
  group_by(site.name, date.deployed) %>%
  filter(site.name %in% c("EUS", "EFL", "ENN")) %>%
  summarize(mean.particulate = mean(particulate.conc.mg.l), 
            mean.om.percent=mean(om.percent), 
            mean.om.conc.mg.l=mean(om.conc.mg.l), 
            d13c.org=mean(d13c.org, na.rm=TRUE), 
            d15n=mean(d15n, na.rm=TRUE), 
            mean.chlA=mean(chlA.ug.L, na.rm=TRUE), 
            mean.sed.rate.g.m2.day=mean(sed.rate.g.m2.day), 
            mean.chl.deposition.rate.mg.m2.day=mean(chl.depositon.rate.mg.m2.day, na.rm=TRUE), 
            c.percent.org=mean(c.percent.org, na.rm=TRUE), 
            n.percent=mean(n.percent, na.rm=TRUE), 
            om.sed.rate.g.m2.day=mean(om.sed.rate.g.m2.day, na.rm=TRUE)) %>%
  mutate(cn=c.percent.org/n.percent) %>%
  mutate(nc=n.percent/c.percent.org)

trap_table <- trap_filtered %>%
  summarize(Sediment.deposition.rates=mean(mean.sed.rate.g.m2.day, na.rm=TRUE), 
            "Chlorophyll a deposition rates (mg m<sup>-2</sup> day<sup>-1</sup>)"=mean(mean.chl.deposition.rate.mg.m2.day, na.rm=TRUE), 
            "OM deposition rates (g OM m<sup>-2</sup> day<sup>-1</sup>)"=mean(om.sed.rate.g.m2.day, na.rm=TRUE),
            "Sediment OM (%)"=mean(mean.om.percent, na.rm=TRUE), 
            "&delta;<sup>15</sup>N"=mean(d15n, na.rm=TRUE), 
            "&delta;<sup>13</sup>C<sub>org</sub>"=mean(d13c.org, na.rm=TRUE), 
            "%N"=mean(n.percent, na.rm=TRUE), 
            "%C<sub>org</sub>"=mean(c.percent.org, na.rm=TRUE),
            "C<sub>org</sub>:N"=mean(cn, na.rm=TRUE)) %>% 
  arrange(desc(Sediment.deposition.rates)) %>%
  mutate("Site" = ifelse(site.name=="EFL", "Lacustrine (L3)", ifelse(site.name=="ENN", "Transitional(T1)","Riverine (R1)"))) %>%
  select("Site", "Sediment deposition rates (g m<sup>-2</sup> day<sup>-1</sup>)"=Sediment.deposition.rates, 3:10) %>%
  mutate_if(is.numeric, funs(round(.,2))) #%>%
#  remove_rownames() %>%
#  column_to_rownames(var="Site") 
#  
#st_table <- htmlTable(trap_table,
#                      caption="Table 4. Sediment trap data. Sediment traps were deployed during the summer of 2016.",
#                      width="500px")
#htmlTableWidget(st_table)      
#trap_table_mod <- trap_table %>%
#  rownames_to_column(var="Site")
#write.table(trap_table_mod, "results/tables/table4_sed_traps.txt", sep=",", row.names = FALSE)

write.xlsx(trap_table, "results/tables/table4_sediment_traps.xlsx")
rm(trap)
rm(trap_calculations)
rm(trap_filtered)
rm(trap_table)

#tidyHtmlTable(trap_table,
#              caption="Table 4. Sediment trap data. Sediment traps were deployed during the summer of 2016.",
#              width="500px")






#### Table 5: Model hypothesis testing results ####
# Manually made.






#### Optional: save as html tables ####

#all_tables <- list()
#htmlTable::htmlTable(trap_EUS_summary) -> all_tables[["Test Table"]]
#htmlTable::htmlTable(trap_calculations) -> all_tables[["Test Table 2"]]
#htmlTable::htmlTable(txtRound(trap_summary, 1)) -> all_tables[["ST Test Table"]]
#htmlTable::concatHtmlTables(all_tables)
#print(table)
#write.table(trap_calculations, "results/tables/test2.txt", sep=",")
