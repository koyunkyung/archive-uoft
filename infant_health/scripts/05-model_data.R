#### Preamble ####
# Purpose: Models for predicting the health status of the infant with data of drugs usage during labor and delivery
# Author: Yunkyung Ko
# Date: 23 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites:
  # - The `tidyverse`, `randomForest` package must be installed and loaded
  # - 03-clean_data.R must have been run
# Any other information needed? Make sure you are in the `infant_health` rproj


#### Workspace setup ####
library(randomForest)
library(caret)
library(rstanarm)
library(tidyverse)


#### Read data ####
infant_balanced <- read_csv("data/02-analysis_data/infant_balanced.csv")
train_data <- read_csv("data/02-analysis_data/train_test_data/train_data.csv")
test_data <- read_csv("data/02-analysis_data/train_test_data/test_data.csv")

# Ensure binary variables are factors
infant_balanced <- infant_balanced %>%
  mutate(across(c("indc", "augmt", "ster", "antb", "chor", "anes"), as.factor))
train_data <- train_data %>%
  mutate(across(c("indc", "augmt", "ster", "antb", "chor", "anes"), as.factor))
test_data <- test_data %>%
  mutate(across(c("indc", "augmt", "ster", "antb", "chor", "anes"), as.factor))

# Model 1: Random Forest Model with Hyperparameter Tuning
set.seed(853)
# Step 1: Define the training control
control <- trainControl(
  method = "cv",  # Cross-validation
  number = 5,     # Number of folds
  search = "grid" # Use a grid search for hyperparameter tuning
)

# Step 2: Define the tuning grid
grid <- expand.grid(
  mtry = c(2, 3, 4)  # Number of variables randomly sampled at each split
)

# Step 3: Fit the random forest model using caret::train
rf_tuned <- caret::train(
  apgar5 ~ indc + augmt + ster + antb + chor + anes,  # Formula
  data = train_data,  # Dataset
  method = "rf",      # Random forest method
  trControl = control,  # Training control
  tuneGrid = grid,      # Hyperparameter grid
  ntree = 500,          # Number of trees
  importance = TRUE     # Variable importance calculation
)



# Model 2: Bayesian Linear Model
bayesian_model <- stan_glm(
  apgar5 ~ indc + augmt + ster + antb + chor + anes,
  data = train_data,
  family = gaussian(),  # For continuous response variable
  prior = normal(0, 2),  # Specify priors for coefficients
  prior_intercept = normal(5, 2),  # Prior for intercept
  chains = 4,  # Number of MCMC chains
  iter = 2000,  # Number of iterations per chain
  seed = 123  # For reproducibility
)


#### Save model ####
saveRDS(rf_tuned, file = "models/random_forest.rds")
saveRDS(bayesian_model, file = "models/bayesian_lm.rds")


