#### Run mixing model to calculate proportion of autochthonous OM in bulk sediment ####
### Megan Berberich 
### HarshaSedCH4_LimnolOcean_2018 



#### INTRODUCTION ####

# This R script calculates the proportions of sources found in each sediment sample from Harsha Lake using a mixing model. The mixing model used here is a Bayesian mixing model, using the MixSIAR package. MixSIAR uses JAGS (Just Another Gibbs Sampler) software to perform MCMC sampling, so this must be installed first (see 'dependencies' below). 

# The code is organized by the following workflow:
# 1. load data files
# 2. pre-model checks
# 3. choose model structure options
# 4. run the JAGS model
# 5. use diagnostics to decide if the model has converged
# 6. analyze output (check summary statistics and posterior density plots)

# For information on MixSIAR package, see the manual (https://github.com/brianstock/MixSIAR/blob/master/Manual/mixsiar_manual_3.1.pdf) and the references containted within. 


#### DEPENDENCIES ####

# JAGS (Just Another Gibbs Sampler) - needs to be downloaded and can be found on Source Forge (yikes)

## load packages
library(dplyr)
library(ggplot2)
library(openxlsx)
library(gridExtra)
library(MixSIAR)
library(tibble)

source('code/utilities.R')

set.seed(1026)


#### LOAD DATA FILES ####

# load mixture data
mixture.file <- "data/process/mixing_model/inputs/mixing_model_isotopes_NC_15N.csv"
mix <- load_mix_data(filename = mixture.file,
                     iso_names = c("NC", "d15N"),
                     factors = "sample",     
                     fac_random = TRUE,       
                     fac_nested = NULL,      
                     cont_effects = NULL)      
rm(mixture.file)

# load source data
source.file <- "data/process/mixing_model/inputs/harsha_sources_isotopes_NC_15N.csv"
source <- load_source_data(filename = source.file,
                           source_factors = NULL,
                           conc_dep = FALSE,     
                           data_type = "raw", mix)
rm(source.file)

# load discrimination file
discr.file <- "data/process/mixing_model/inputs/harsha_discrimination.csv"
discr <- load_discr_data(filename = discr.file, mix)
rm(discr.file)



#### PRE-MODEL CHECKS ####

# plot data in an isospace plot
plot_data(filename = "isospace_plot", plot_save_pdf = FALSE,
          plot_save_png = FALSE, mix, source, discr)

# calculate convex hull area
calc_area(source = source, mix = mix, discr = discr)

# plot prior
# we will use the default "UNIFORMATIVE/GENERALIST prior (alpha = 1)"
plot_prior(alpha.prior = 1, source, plot_save_pdf = FALSE)


#### DEFINE JAGS MODEL STRUCTURE ####

model_filename <- "data/process/mixing_model/outputs/mixSIAR_model.txt"
resid_err <- TRUE 
process_err <- TRUE 
write_JAGS_model(model_filename, resid_err, process_err, mix, source)


#### RUN JAGS MODEL ####

# For "run", can specify length of run ("test", "very short", "short", "normal", "long", "very long", "extreme"). The chain length for "test" is 1000, "normal" is 100,000, and "extreme" is 3,000,000. Need to run long enough that the model converges.

jags.1 <- run_model(run = "long", mix, source, discr, model_filename, alpha.prior = 1, resid_err, process_err)


#### ANALYZE DIAGNOSTICS AND OUTPUT ####

output_options <- list(summary_save = TRUE,
                       summary_name = "data/process/mixing_model/outputs/summary_statistics",
                       sup_post = FALSE,
                       plot_post_save_pdf = TRUE,
                       plot_post_name = "data/process/mixing_model/outputs/posterior_density",
                       sup_pairs = FALSE,
                       plot_pairs_save_pdf = FALSE,
                       plot_pairs_name = "data/process/mixing_model/outputs/pairs_plot",
                       sup_xy = TRUE,
                       plot_xy_save_pdf = TRUE,
                       plot_xy_name = "data/process/mixing_model/outputs/xy_plot",
                       gelman = TRUE,
                       heidel = TRUE,
                       geweke = TRUE,
                       diag_save = TRUE,
                       diag_name = "data/process/mixing_model/outputs/diagnostics",
                       indiv_effect = FALSE,
                       plot_post_save_png = FALSE,
                       plot_pairs_save_png = FALSE,
                       plot_xy_save_png = FALSE)



output_JAGS(jags.1, mix, source, output_options)
rm(mix)
rm(discr)
rm(output_options)
rm(resid_err)
rm(process_err)
rm(model_filename)
rm(jags.1)
rm(source)

#### SAVE AUTOCTHONOUS OM PROPORTION VALUES IN EXCEL FILE ####

auto_proportions <- read.table(file = "data/process/mixing_model/outputs/summary_statistics.txt", skip = 7, header = TRUE) 
sample_info <- read.xlsx("data/raw/sample_information.xlsx")
auto_proportions <- auto_proportions[4:49,]

sample_names <- strsplit(rownames(auto_proportions), "[.]")
rownames(auto_proportions) <- sapply(sample_names, `[`,2)

auto_proportions <- auto_proportions %>%
  select(Mean, SD) %>%
  rename(om.autoc.proportion = Mean) %>%
  rename(om.autoc.SD = SD) %>%
  rownames_to_column() %>%
  rename(sample.id = rowname) %>%
  inner_join(sample_info, auto_proportions, by = "sample.id") %>%
  select(sample.id, site.number, site.name, core, zone, site.id, om.autoc.proportion, om.autoc.SD)
   
write.xlsx(auto_proportions, "data/process/autochthonous_om_proportion.xlsx")
rm(sample_info)
rm(sample_names)
rm(auto_proportions)


#### OPTIONAL PLOT AND STATS ####

#nestedANOVA(auto_proportions$om.autoc.proportion, auto_proportions$zone, auto_proportions$site.number)

#ggplot(auto_proportions, aes(zone, om.autoc.proportion)) +
#  geom_boxplot(outlier.size = 0, outlier.colour = NULL) +
#  labs(y=expression(Proportion~of~autochthonous~OM~""),
#       x=expression("")) +
#  scale_x_discrete(limits = c("riverine", "transitional", "lacustrine")) + ggtitle("B") +
#  theme(panel.background = element_rect(fill = "white"),
#        panel.grid.major = element_blank(),
#        text=element_text(size=12),
#        plot.title = element_text(face="bold", hjust = -0.065, size = 20), 
#        panel.border = element_rect(size = 1, fill = NA)) +
#  geom_jitter() +
#  annotate('text', x = 1, y = .61, 
#           label = " a ",parse = TRUE,size=5) +
#  annotate('text', x = 2, y = .61, 
#           label = " b ",parse = TRUE,size=5) +
#  annotate('text', x = 3, y = .61, 
#           label = " c ",parse = TRUE,size=5)










