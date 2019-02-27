#### Run code in sequence ####
#### Berberich_HarshaSedCH4_LimnolOcean_2019
#### Megan Berberich

## Open packages
source('code/utilities.R')

## Calculate methane production rates
source('code/calculate_CH4_production_rates.R')

## Run mixing model to estimate proportion of autochthonous OM in bulk sediment
source('code/run_mixing_model.R')

## Build master file
source('code/build_master_file_sample.R')

## Verify numbers in results section
source('code/generate_results_statistics.R')

## Run PLS analysis
source('code/run_pls.R')

## Generate tables
source('code/generate_tables.R')

## Generate figures
## Code for Figure 8 (PLS) and SI for PLS is in run_pls.R above
source('code/generate_figure_2_methane_prod_rates.R')
source('code/generate_figure_3_om_quantity.R')
source('code/generate_figure_4_proportion_autoc.R')
source('code/generate_figure_5_dom_optical_properties.R')
source('code/generate_figure_6_methanogen_heatmap_genus.R')
source('code/generate_figure_7_methane_production_pathway.R')
