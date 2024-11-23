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

# Hyperparameter tuning for Random Forest
set.seed(853)
control <- trainControl(method = "cv", number = 5)  # 5-fold cross-validation
grid <- expand.grid(mtry = seq(2, 6, by = 1))  # Search for mtry between 2 and 6

rf_tuned <- train(
  apgar5 ~ indc + augmt + ster + antb + chor + anes,
  data = train_data,
  method = "rf",
  trControl = control,
  tuneGrid = grid,
  ntree = 500,  # Number of trees
  importance = TRUE
)


#### Save model ####
saveRDS(rf_tuned, file = "models/random_forest.rds")



