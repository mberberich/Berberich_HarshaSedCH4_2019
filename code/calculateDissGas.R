# SCRIPT FOR CALCULATING OBSERVED AND SATURATED DISSOLVED GAS CONCENTRATIONS
# USES FUNCTIONS FROM 10/6/2017 snapshot of NEON dissGas PACKAGE.  

source("code/def.calc.sdg.R") # source function

# Read data provided to JB by MB on 9/17/2019
dgData <- read.xlsx("data/site_dissolved_ch4.xlsx",
                    rows = 1:16) %>% # omit summary statistics rows
  rename_all(tolower) %>% # lowercase letters for column names
  select(-contains("mean"), -contains("um")) %>% # omit previously calculated values
  pivot_longer(cols = contains("ch4")) %>% # melt to long
  rename(depth.zone = name, 
         ch4.ppm = value) %>%
  # populate depth.zone with 'deep' or 'shallow'
  mutate(depth.zone = ifelse(grepl(pattern = "shallow", 
                                   x = depth.zone),
                             "shallow",
                             ifelse(grepl(pattern = "deep",x = depth.zone),
                                    "deep",
                                    NA)))

dgData <- with(dgData, 
               def.calc.sdg(inputFile = dgData,
                            volGas = 25, # volume of gas in headspace equilibration
                            volH2O = 120, # volume of water in headspace equilibration
                            baro = 101, # kPa
                            waterTemp = 25, # lake water temp.  Used to calculate equilibrium concentration
                            headspaceTemp = 23, # Temperature of headspace equilibration.  Done in field, right?
                            eqCO2 = NA, # not reported
                            sourceCO2 = NA, # not reported
                            airCO2 = NA, # not reported
                            eqCH4 = ch4.ppm, # measured in equilibrated headspace
                            sourceCH4 = 0, # Used He,  Replace with air value if He not used 
                            airCH4 = 1.85, # global mean.  Used for equilibrium concentration
                            eqN2O = NA, # not reported
                            sourceN2O = NA, # not reported 
                            airN2O = NA)) # not reported

dgData <- dgData %>%
  rename(dissolvedCH4.M = dissolvedCH4) %>% # mol gas/L
  mutate(dissolvedCH4.uM = dissolvedCH4.M * 1000000) #umol gas/L
  
  