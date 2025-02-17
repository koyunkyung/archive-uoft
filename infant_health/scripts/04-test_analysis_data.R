#### Preamble ####
# Purpose: Tests the structure and validity of the analysis dataset.
# Author: Yunkyung Ko
# Date: 23 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - The `tidyverse`, `testthat` package must be installed and loaded
# - 03-clean_data.R must have been run 
# Any other information needed? Make sure you are in the `infant_health` rproj

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the dataset
balanced_data <- read_csv("../data/02-analysis_data/infant_balanced.csv")
balanced_data <- balanced_data %>%
  mutate(across(c("indc", "augmt", "ster", "antb", "chor", "anes"), ~ as.factor(.)))

#### Test 1: Dataset structure ####
test_that("Dataset structure is correct", {
  # Test that the dataset has 22000 rows
  expect_equal(nrow(balanced_data), 22000)
  
  # Test that the dataset has 7 columns
  expect_equal(ncol(balanced_data), 7)
  
  # Test column names
  expected_columns <- c("indc", "augmt", "ster", "antb", "chor", "anes", "apgar5")
  expect_true(all(expected_columns %in% colnames(balanced_data)),
              "The dataset is missing one or more required columns.")
})

#### Test 2: Variable types ####
test_that("All specified columns have correct data types", {
  # Test that binary variables are factor
  binary_variables <- c("indc", "augmt", "ster", "antb", "chor", "anes")
  for (var in binary_variables) {
    expect_true(is.factor(balanced_data[[var]]),
                paste("Variable", var, "is not a factor."))
  }
  
  # Test that apgar5 is numeric and integer
  expect_true(is.numeric(balanced_data$apgar5) & all(balanced_data$apgar5 %% 1 == 0),
              "apgar5 is not an integer.")
})

#### Test 3: Binary variable values ####
test_that("Binary variables contain only 0 or 1 as values", {
  binary_variables <- c("indc", "augmt", "ster", "antb", "chor", "anes")
  for (var in binary_variables) {
    expect_true(all(unique(as.numeric(levels(balanced_data[[var]])[balanced_data[[var]]])) %in% c(0, 1)),
                paste("Variable", var, "contains values other than 0 or 1."))
  }
})

#### Test 4: apgar5 distribution ####
test_that("apgar5 values are within range 0 to 10 and balanced", {
  # Check range
  expect_true(all(balanced_data$apgar5 >= 0 & balanced_data$apgar5 <= 10),
              "apgar5 is not within the range 0 to 10.")
  
  # Check balanced distribution
  desired_sample_size <- 2000
  apgar5_counts <- balanced_data %>%
    count(apgar5) %>%
    filter(apgar5 >= 0 & apgar5 <= 10)
  
  for (score in 0:10) {
    count <- apgar5_counts %>% filter(apgar5 == score) %>% pull(n)
    expect_true(count == desired_sample_size,
                paste("apgar5 value", score, "does not have", desired_sample_size, "observations."))
  }
})