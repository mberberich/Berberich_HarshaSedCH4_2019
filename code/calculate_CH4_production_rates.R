
#### Calculate CH4 production rates from sediment slurries ####
### Megan Berberich 
### HarshaSedCH4_LimnolOcean_2018 

# Open required packages
source('code/utilities.R')

#### PREPARE DATA ####

# Read in file that has sediment slurry incubation slurries
slurry_data <- read.xlsx("data/raw/ch4_slurry_data_may.xlsx")

# Create new data frame with using the slurry_data and arrange dataset so that all of the same samples are grouped together. 
umol_calculations <- arrange(slurry_data, sample)
rm(slurry_data)
# Create a new column with hour sampled converted to day sampled by dividing hours by 24.
umol_calculations$day_sampled <- with(umol_calculations, hour_sampled/24)


#### CALCULATE MOLS OF CH4 ####

# use ideal gas law (PV = nRT), and solve for n (n = PV/RT), where
# R is the gas constant (8.3145 L kPa / mol * K),
# T is temperature in kelvin (K) - here room temperature was 23˚C, so 296.15K, 
# P is pressure in kPa - here atmospheric pressure is 101 kPa, and
# V, expressed in L, will be the sum of the known volume of the serum bottle plus the volume of gas that was displaced (measure by insertering a syringe with a needle attached). The volume of headspace in the serum bottle is 90 mL. 

# Add a column with total volume (in L) to umol_calculations.
umol_calculations$total_volume_L <- with(umol_calculations, (90+volume_gas_displaced_mL)/1000)

# Add a column to umol_calculations with calculation of n, using n = PV/RT:
umol_calculations$n_moles_air <- with(umol_calculations, (101 * total_volume_L)/(8.3145 * 296.15))



#### ACCOUNT FOR DILUTION DURING SAMPLING ####

# This method of accounting for dilution during gas sampling aims at quantifying all mols of CH4 and keeping track of them. Essentially, we have the known mols of CH4 in the serum bottle at each sampling period, and need to track the mols that have been removed each time a gas sample is taken.
 
# Add a column with the umol of CH4 in the serum bottle at each sampling time point.
umol_calculations$umol_CH4_serum <- with(umol_calculations, (n_moles_air * (CH4_ppm/1000000))*1000000) 

# Next, we need to calculate the moles of CH4 that were taken out at each sampling time point. We do this by first determining n (the moles of air) in the syringe at each time point and then multiplying by the CH<sub>4</sub> ppm. Using the ideal gas law ($n = PV/RT$) we will use 286.15 K for $T$, atmospheric pressure (101 kPa) for $P$, 8.3145 L kPa mol<sup>1</sup> K<sup>1</sup> for $R$, and the volume ($V$) of each gas sample was 11 mL. 

# Define n moles air in syringe. This will be same for each gas sample because each gas sample had the same pressure (atmospheric) and was the same volume (11 mL). 
n_moles_air_syringe <- (101 * 0.011)/(8.3145 * 296.15)

# Now we can calculate the moles of CH<sub>4</sub> in the syringe by multiplying the ppm by the moles of air in the syringe. 

# Add a column with the umol of CH4 in the syringe at each sampling time point. 
umol_calculations$umol_CH4_syringe <- with(umol_calculations, CH4_ppm * n_moles_air_syringe)
rm(n_moles_air_syringe)

# We need to add the umol CH<sub>4</sub> in the syringe to the umol CH<sub>4</sub> in the serum bottle for each time point. Futher, we need to add the umol CH<sub>4</sub> in the syringe at each previous time point. For example, the total umol at TP3 is equal to the umol in the serum bottle plus umol in the syringe at TP3, TP2 and TP1. 

for (i in 1:length(umol_calculations$time_point)){
  if(umol_calculations$time_point[i]==1) {umol_calculations$umol_CH4_total[i] <- umol_calculations$umol_CH4_serum[i]}
  else if(umol_calculations$time_point[i]==2) {umol_calculations$umol_CH4_total[i] <- umol_calculations$umol_CH4_serum[i] + umol_calculations$umol_CH4_syringe[i-1]}
  else if(umol_calculations$time_point[i]==3) {umol_calculations$umol_CH4_total[i] <- umol_calculations$umol_CH4_serum[i] + umol_calculations$umol_CH4_syringe[i-1] + umol_calculations$umol_CH4_syringe[i-2]}
  else if(umol_calculations$time_point[i]==4) {umol_calculations$umol_CH4_total[i] <- umol_calculations$umol_CH4_serum[i] + umol_calculations$umol_CH4_syringe[i-1] + umol_calculations$umol_CH4_syringe[i-2] + umol_calculations$umol_CH4_syringe[i-3]}
  else if(umol_calculations$time_point[i]==5) {umol_calculations$umol_CH4_total[i] <- umol_calculations$umol_CH4_serum[i] + umol_calculations$umol_CH4_syringe[i-1] + umol_calculations$umol_CH4_syringe[i-2] + umol_calculations$umol_CH4_syringe[i-3] + umol_calculations$umol_CH4_syringe[i-4]}
  else if(umol_calculations$time_point[i]==6) {umol_calculations$umol_CH4_total[i] <- umol_calculations$umol_CH4_serum[i] + umol_calculations$umol_CH4_syringe[i-1] + umol_calculations$umol_CH4_syringe[i-2] + umol_calculations$umol_CH4_syringe[i-3] + umol_calculations$umol_CH4_syringe[i-4] + umol_calculations$umol_CH4_syringe[i-5]}
}


#### CALCULATE CH4 PRODUCTION RATES ####

# Next, calculate methane production rates and add to the "methanogenesis_rate" data frame. This data frame will then have rates in umol/day and umol/cm3/day as well as the r squared values for both method 1 and method 2 of the diltuion correction.

# Note that the rates expressed here are in umol/day 

# Create a new data frame with rates of methane production
dt1 <- data.table(umol_calculations)
methanogenesis_rates <- dt1[,list(umol_CH4_day=lm(umol_CH4_total~day_sampled)$coef[2]), by=sample]



# Add a column with umol/cm-3/day
# Rates expressed umol/day are divided by 15, which is the volume of sediment per slurry
methanogenesis_rates$umol_CH4_day_cm3 <- with(methanogenesis_rates, umol_CH4_day/15)

# Make a data frame with the r-squared value
r_squared <- dt1[,list(r_squared=summary(lm(umol_CH4_total~day_sampled))$r.squared), by=sample]

# Merge the data frames
methanogenesis_rates <- merge(methanogenesis_rates, r_squared, by="sample")


# Get rid of intermediate data tables
rm(dt1)
rm(r_squared)
rm(i)

# Remove the "kill" samples from the methanogenesis rates:
methanogenesis_rates <- methanogenesis_rates[-c(2, 7, 13, 17, 20, 23, 28, 33, 35, 41, 43, 48, 53, 55, 60), ]


#### CHECK FIT OF LINEAR REGRESSIONS (RATES) ####

# Most of the fits (R squared) values look very good for the methane production rates, however, there are a couple (Sample 6C, for example) that are not ideal. This is likely due to a gas sample that did not get taken properly or something of that nature. To filter out any bad fits, let's find all rates that have a fit of less than 0.95. 

filter(methanogenesis_rates, r_squared < 0.95)

# We see that there are only 5 samples with an R squared of less than 0.95, so let's take a closer look at the timepoint plots for these samples: 
ggplot((subset(umol_calculations, sample=="06C"|sample== "07A"|sample== "07C"|sample== "10B"|sample== "12A")),aes(hour_sampled, umol_CH4_total)) +
  geom_point() +
  facet_grid(.~sample)

# Now let's remove some of the points that are obviously not in line with the others. Note that these can be verified first by looking at the CH4 ppm (in the umol_calculations data frame) before removing.

# * T4 for sample 06C (row 148)

# * T3 for sample 07A (row 153)

# * T4 for sample 07C (row 172)

# * T3 for sample 10B (row 231)

# * T3 for sample 12A (row 273)

# Remove points that are leading to bad fit: 

umol_calculations <- umol_calculations[-c(148, 153, 172, 231, 273), ]


# Now let's re-calculate methane production rates (Note that the rates expressed here are in umol/day): 

# Create a new data frame with rates of methane production
dt1 <- data.table(umol_calculations)
methanogenesis_rates <- dt1[,list(umol_CH4_day=lm(umol_CH4_total~day_sampled)$coef[2]), by=sample]

# Add a column with umol/cm-3/day
methanogenesis_rates$umol_CH4_day_cm3 <- with(methanogenesis_rates, umol_CH4_day/15)

# Make a data frame with the r-squared value
r_squared <- dt1[,list(r_squared=summary(lm(umol_CH4_total~day_sampled))$r.squared), by=sample]

# Merge the data frames
methanogenesis_rates <- merge(methanogenesis_rates, r_squared, by="sample")

# Remove the "Kill" samples again
methanogenesis_rates <- methanogenesis_rates[-c(2, 7, 13, 17, 20, 23, 28, 33, 35, 41, 43, 48, 53, 55, 60), ]

# Get rid of intermediate data tables
rm(dt1)
rm(r_squared)


# Let's check to be sure that removing those points improved the R-squared value:
filter(methanogenesis_rates, r_squared < 0.95)

# We can even re-plot the ones that were trouble before (if desired):
ggplot((subset(umol_calculations, sample=="06C"|sample== "07A"|sample== "07C"|sample== "10B"|sample== "12A")),aes(hour_sampled, umol_CH4_total)) +
  geom_point() +
  facet_grid(.~sample)

#### EXPRESS CH4 PRODUCTION RATES IN DIFFERENT UNITS ####

# Express CH4 production by area (cm^2). Do this by multiplying the umol ch4/cm^3/day by 5, because the core was 5 cm deep (to get umol ch4/cm^2/day)

methanogenesis_rates$umol_CH4_day_cm2 <- methanogenesis_rates$umol_CH4_day_cm3 * 5

# Now let's convert to mol (instead of umol) and m^2 (instead of cm^2):
methanogenesis_rates$mol_CH4_day_m2 <- (methanogenesis_rates$umol_CH4_day_cm2/1000000) * 10000

# Let's get milligrams (mg) of C (in ch4) per m^2 per day.
# First multiply mol ch4 per m2 per day by 12 (molar mass of C) to get g of C-CH4, then multiply by 1000 to convert g to mg
methanogenesis_rates$mg_c_CH4_m2_day <- (methanogenesis_rates$mol_CH4_day_m2 * 12) * 1000

# Convert that to mg C-CH4 per m2 per HOUR (divide by 24 because 24 hours in a day):
methanogenesis_rates$mg_c_CH4_m2_hour <- (methanogenesis_rates$mg_c_CH4_m2_day / 24)

# Add column with mg CH4 per m2 per hour
# Multiply mol ch4 per m2 per day by 16.04 (molar mass of CH4) to get g of CH4, then mulitply by 1000 to convert g to mg and divide by 24 to get the rate per hour
methanogenesis_rates$mg_CH4_m2_hour <- ((methanogenesis_rates$mol_CH4_day_m2 * 16.04) * 1000) / 24

#### SAVE OUTPUT FILES ####

# The last thing we need to do is save the output files in the ~/data/process/ directory:

# Add columns with the sample number and site information next to each sample.
sample_info <- read.xlsx("data/raw/sample_information.xlsx")

methanogenesis_rates$sample.id <- sample_info$sample.id
methanogenesis_rates$zone <- sample_info$zone
methanogenesis_rates$site.number <- sample_info$site.number
methanogenesis_rates$core <- sample_info$core
rm(sample_info)

# Reorder columns
methanogenesis_rates <- methanogenesis_rates[,c(10:13, 1, 2:9)]
methanogenesis_rates <- methanogenesis_rates[, -5]


# Write to xlsx
write.xlsx(methanogenesis_rates, "data/process/ch4_methanogenesis_rates_may.xlsx")
write.xlsx(umol_calculations, "data/process/ch4_slurry_umol_calculations_may.xlsx")

rm(umol_calculations)
rm(methanogenesis_rates)



