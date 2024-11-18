#### Preamble ####
# Purpose: Tests the structure and validity of the analysis dataset.
# Author: Yunkyung Ko
# Date: 17 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites:
  # - The `tidyverse`, `testthat` package must be installed and loaded
  # - 03-clean_data.R must have been run 
# Any other information needed? Make sure you are in the `infant_health` rproj


#### Workspace setup ####
library(tidyverse)
library(testthat)
infant_health <- read_csv("../data/02-analysis_data/infant_health.csv")

#### Test dataset structure ####
# Test that the dataset has 3479516 rows
test_that("dataset has 3479516 rows", {
  expect_equal(nrow(infant_health), 3479516)
})

# Test that the dataset has 11 columns
test_that("dataset has 11 columns", {
  expect_equal(ncol(infant_health), 11)
})

#### Test for missing values ####
# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(infant_health)))
})

#### Test for variable types ####
# Define expected types for each column - numeric types
# Test variable types
test_that("numeric variables have correct types", {
  expected_types <- list(
    dem_momage = "double",    
    dem_dadage = "double",    
    mom_bmi = "double",       
    med_previs = "double",    
    inft_weight = "double",   
    inft_gest = "double"      
  )
  for (var in names(expected_types)) {
    if (var %in% colnames(infant_health)) {
      expect_type(infant_health[[var]], expected_types[[var]]
      )
    } else {
      fail(paste("Variable", var, "is not in the dataset."))
    }
  }
})


# Test binary variables
test_that("binary variables contain only 0 or 1", {
  binary_variables <- c("mom_notobaco", "mom_noinfec", "med_wic", "no_abnorm", "no_congen")  # Add all binary variable names here
  for (var in binary_variables) {
    if (var %in% colnames(infant_health)) {
      expect_true(
        all(infant_health[[var]] %in% c(0, 1), na.rm = TRUE),
        paste("Variable", var, "contains values other than 0 or 1.")
      )
    } else {
      fail(paste("Variable", var, "is not in the dataset."))
    }
  }
})