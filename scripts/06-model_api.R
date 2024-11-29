#### Preamble ####
# Purpose: API for serving predictions from Random Forest and Bayesian Linear Models for health status of infants
# Author: Yunkyung Ko
# Date: 28 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - The `plumber` package must be installed and loaded
# - 05-model_data.R must have been run
# Any other information needed? Make sure you are in the `infant_health` rproj

# Load necessary library
library(plumber)

# Load models from RDS files
random_forest_model <- readRDS("../models/random_forest.rds")
bayesian_model <- readRDS("../models/bayesian_lm.rds")

#* @apiTitle Infant Health Prediction API
#* @apiDescription API for predicting infant health status based on drugs used during labor and delivery

#* Predict using a numeric vector of features (JSON input)
#* @param features A numeric vector of features (e.g., maternal age, drug usage indicators)
#* @post /predict
function(features) {
  # Validate input
  if (is.null(features) || !is.numeric(unlist(features))) {
    stop("Invalid input: 'features' must be a numeric vector")
  }
  
  # Convert input to numeric vector
  features <- as.numeric(unlist(features))
  
  # Ensure features are in the correct format for prediction
  features_df <- as.data.frame(t(features))  # Convert to data frame for compatibility
  
  # Predict using Random Forest model
  rf_prediction <- predict(random_forest_model, newdata = features_df, type = "response")
  
  # Predict using Bayesian Linear model
  bayesian_prediction <- predict(bayesian_model, newdata = features_df, type = "response")
  
  # Return predictions as a list
  list(
    random_forest_prediction = rf_prediction,
    bayesian_linear_model_prediction = bayesian_prediction
  )
}

#* Predict using a local CSV file path
#* @post /predict_csv_local
function() {
  # Specify the correct relative path to the test_data.csv
  csv_path <- "../data/02-analysis_data/train_test_data/test_data.csv"
  
  # Load the CSV file
  features_df <- read.csv(csv_path)
  
  # Validate that all columns in the CSV are numeric
  if (!all(sapply(features_df, is.numeric))) {
    stop("Invalid input: All columns in the CSV file must be numeric")
  }
  
  # Predict using Random Forest model
  # Adjust the type based on the task (classification or regression)
  rf_predictions <- predict(random_forest_model, newdata = features_df, type = "raw")
  
  # Predict using Bayesian Linear model (no changes needed for this model)
  bayesian_predictions <- predict(bayesian_model, newdata = features_df, type = "response")
  
  # Combine results into a data frame
  results <- data.frame(
    Random_Forest_Predictions = rf_predictions,
    Bayesian_Linear_Model_Predictions = bayesian_predictions
  )
  
  # Return predictions as a data frame
  return(results)
}

