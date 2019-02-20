#### Build master file for all variables corresponding to a sample ####
### Megan Berberich 
### HarshaSedCH4_LimnolOcean_2018 


#### LIST OF INCLUDED DATA ####
##
## Note: this cannot be run until the methane production rates are calculated (calculate_CH4_production_rates.R) and the proportion of autochthonous OM is calculated via the mixing model (run_mixing_model.R)
##
## CH4 production rates (multiple units): ch4
## 
## Sediment bulk density: density
## Sediment percent water: water
## Sediment percent OM: om
## Sediment %N: ea
## Sediment %C: ea
## Sediment 15N: ea
## Sediment 13C: ea
## Sediment C/N: ea
## Sediment N/C: ea
## Sediment proportion autocthonous OM (calculated from mixing model): autoc
## 
## Porewater DOC: dom
## Porewater EEMS - humification index (HIX): dom
## Porewater EEMS - fluorescence index (FI): dom
## Porewater EEMS - biological index (BIX): dom
## Porewater EEMS - relative fluorescence efficiency (RFE): dom
## Porewater EEMS - SUVA254: dom
## Porewater VFA - acetic acid: vfa
## 
## Methanogens - methanogen abundance: qpcr
## Methanogens - archaeal abundance: qpcr
## 
## Gas isotopes - 13C-CO2
## Gas isotopes - 13C-CH4 
## 
## 

#### READ IN DATA AND SELECT VARIABLES TO BE INCLUDED ####

# Open required packages
source('code/utilities.R')

info <- read.xlsx("data/raw/sample_information.xlsx")

ch4 <- read.xlsx("data/process/ch4_methanogenesis_rates_may.xlsx") %>%
  dplyr::select(sample.id, umol.CH4.day = umol_CH4_day, umol.CH4.day.cm3 = umol_CH4_day_cm3, umol.CH4.day.cm2 = umol_CH4_day_cm2, mg.c.CH4.m2.hour = mg_c_CH4_m2_hour, mg.CH4.m2.hour = mg_CH4_m2_hour)

autoc <- read.xlsx("data/process/autochthonous_om_proportion.xlsx") %>%
  dplyr::select(sample.id, om.autoc.proportion, om.autoc.SD)

om <- read.xlsx("data/raw/sed_om_may.xlsx") %>%
  dplyr::select(sample.id, OM.drywt.percent)

density <- read.xlsx("data/raw/sed_bulk_density_may.xlsx") %>%
  dplyr::select(sample.id, density.g.ml)

water <- read.xlsx("data/raw/sed_percent_water_may.xlsx") %>%
  dplyr::select(sample.id, percent.water)

ea <- read.xlsx("data/raw/sed_ea_isotopes_may.xlsx") %>%
  dplyr::select(sample.id, d15n = d15n_total, d13c.org = d13C_org, n.percent = n_percent, c.percent.org = c_org_percent, cn, nc)

dom <- read.xlsx("data/raw/sed_porewater_fluorescence_indices_calculations_may.xlsx") %>%
  dplyr::select(sample.id, doc.mg.l = doc.mg.L, suva254 = SUVA254, fi = FI.fluorescence.index, bix = BIX.biological.index, rfe = RFE.relative.fluorescence.efficiency, hix = HIX.humification.index) 

vfa <- read.xlsx("data/raw/sed_porewater_acetic_acid_may.xlsx") %>%
  dplyr::select(sample.id, acetic.acid.mg.l = acetic.acid.mg.L)

slurry <- read.xlsx("data/raw/ch4_slurry_dry_wt_final_pressure_may.xlsx") %>%
  dplyr::select(sample.id, slurry.dry.wt.g)

qpcr <- read.xlsx("data/raw/qPCR.xlsx") %>%
  dplyr::select(sample.id, arc.ng.g.sed = ARC_quantity_per_ng_per_g, mcra.ng.g.sed = mcrA_quantity_per_ng_per_g)

gasiso <- read.xlsx("data/raw/gas_isotopes.xlsx") %>%
  dplyr::select(sample.id, d13c.ch4, d13c.co2, fractionation.factor)


#### COMPILE INTO ONE DATAFRAME ####
master <- list(info, autoc, ch4, density, water, dom, ea, om, vfa, slurry, qpcr, gasiso) %>% 
  reduce(left_join, by = "sample.id")

rm(list = c('vfa', 'dom', 'ea', 'info', 'om', 'water', 'density', 'ch4', 'autoc', 'slurry', 'qpcr', 'gasiso'))


#### Additional calculated columns ####
master <- mutate(master, slurry.om.drywt.g = slurry.dry.wt.g * (OM.drywt.percent/100))
master <- mutate(master, umol.CH4.day.g.om = umol.CH4.day / slurry.om.drywt.g)
master <- mutate(master, g.om.per.cm3 = slurry.om.drywt.g/15)
master <- mutate(master, umol.CH4.day.g.sed = umol.CH4.day / slurry.dry.wt.g)


#### WRITE MASTER DATA FILE ####
write.xlsx(master, "data/process/master_by_sample.xlsx")
rm(master)


