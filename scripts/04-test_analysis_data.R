#### Preamble ####
# Purpose: Tests the structure and validity of the analysis dataset.
# Author: Yunkyung Ko
# Date: 18 November 2024
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
# Test that the dataset has 3588588 rows
test_that("dataset has 3588588 rows", {
  expect_equal(nrow(infant_health), 3588588)
})

# Test that the dataset has 7 columns
test_that("dataset has 7 columns", {
  expect_equal(ncol(infant_health), 7)
})

#### Test for missing values ####
# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(infant_health)))
})

#### Test for variable types ####
# Test numeric variables
test_that("apgar5 is of double type", {
  expect_type(infant_health$apgar5, "double")
})


# Test binary variables
test_that("binary variables contain only 0 or 1", {
  binary_variables <- c("indc", "augmt", "ster", "antb", "chor", "anes")  # Add all binary variable names here
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

#### Test for the range of variables ####
test_that("apgar5 values are within the range 0 to 10", {
  expect_true(all(infant_health$apgar5 >= 0 & infant_health$apgar5 <= 10))
})