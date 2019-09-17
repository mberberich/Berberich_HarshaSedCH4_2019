#### Utilities ####
### Megan Berberich
### HarshaSedCH4_LimnolOcean_2018
### 2018-11-24


#### LOAD FREQUENTLY USED PACKAGES ####
library(openxlsx)
library(dtplyr)
library(dplyr)
library(data.table)
library(ggplot2)
library(gridExtra)
library(tibble)
library(purrr)
library(tidyverse)
library(tidyr) # for pivot_longer, verion >+1.0.0



#### DEFINE FUNCTIONS ####

# Define function to run a nested anova (nest.level.1 = zone, nest.level.2 = site)
# See 'code/statistics.R' for use and description
nestedANOVA <- function(response, nest.level.1, nest.level.2) {
  model <- lm(response ~ factor(nest.level.1)/factor(nest.level.2))
  model.output <- anova(model)
  F.value <- model.output[1,3] / model.output[2,3]
  P.value <- (1 - pf(F.value, model.output[1,1], model.output[2,1]))
  Tukey <- TukeyHSD(aov(model))
  return(c(F.value, P.value, Tukey$`factor(nest.level.1)`[,4]))
}



memod <- function(response, fixed.factor, random.factor) {
  factorized.fixed <- as.factor(fixed.factor)
  factorized.random <- as.factor(random.factor)
  model = lmer(response ~ factorized.fixed + (1|factorized.random),
               REML = TRUE)
  model.output <- anova(model)
  resid.plot <- hist(residuals(model),
                     col="darkgray")
  resid.fitted.plot <- plot(fitted(model),
                            residuals(model))
  diff.means <- difflsmeans(model, test.effs = "factorized.fixed")
  return(hello <- as.data.frame(c(model.output, diff.means)))
}

