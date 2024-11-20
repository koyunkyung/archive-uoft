#### Preamble ####
# Purpose: Models for predicting the health status of the infant with data of drugs usage during labor and delivery
# Author: Yunkyung Ko
# Date: 18 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites:
  # - The `tidyverse`, `rstanarm` package must be installed and loaded
  # - 03-clean_data.R must have been run
# Any other information needed? Make sure you are in the `infant_health` rproj


#### Workspace setup ####
library(readr)
library(randomForest)
library(caret)
library(rstanarm)
library(ranger)

#### Read data ####
infant_health <- read_csv("data/02-analysis_data/infant_health.csv")

### Model data ####

# Model 1: Random Forest for Predicting apgar5
set.seed(853)  # Ensure reproducibility
randfor <- ranger(
  formula = apgar5 ~ indc + augmt + ster + antb + chor + anes,  # Formula for the model
  data = infant_health,                                        # Dataset
  num.trees = 500,                                             # Correct argument for number of trees
  mtry = 3,                                                    # Number of variables tried at each split
  importance = "impurity",                                     # Variable importance
  num.threads = 4                                              # Number of cores for parallelism
)


# Model 2: Bayesian GLM for Predicting apgar5
bayeslinear <- stan_glm(
  formula = apgar5 ~ indc + augmt + ster + antb + chor + anes,  # Formula for the model
  data = analysis_data,                                         # Dataset
  family = gaussian(),                                          # Assumes normal errors for continuous outcome
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),  # Priors for coefficients
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE), # Prior for intercept
  prior_aux = exponential(rate = 1, autoscale = TRUE),          # Prior for auxiliary parameters (e.g., sigma)
  seed = 853                                                    # Seed for reproducibility
)


#### Save model ####
saveRDS(randfor, file = "models/random_forest.rds")
saveRDS(bayeslinear, file = "models/bayesian_glm.rds")

