#### Preamble ####
# Purpose: Tests the structure and validity of the US presidential election polls data.
# Author: Yunkyung Ko
# Date: 19 October 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to have downloaded and cleaned the data.
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(testthat)


#### Test data ####
# Test that the dataset has 8 columns
test_that("dataset has 8 columns", {
  harris_data <- read_csv("../data/02-analysis_data/harris_elections_data.csv")
  expect_equal(ncol(harris_data), 8)
})

# Test that the 'pollster' column is character type
test_that("'pollster' is character", {
  harris_data <- read_csv("../data/02-analysis_data/harris_elections_data.csv")
  expect_type(harris_data$pollster, "character")
})

# Test that the 'state' column is character type
test_that("'state' is character", {
  harris_data <- read_csv("../data/02-analysis_data/harris_elections_data.csv")
  expect_type(harris_data$state, "character")
})

# Test that the 'candidate_name' column is character type
test_that("'candidate_name' is character", {
  harris_data <- read_csv("../data/02-analysis_data/harris_elections_data.csv")
  expect_type(harris_data$candidate_name, "character")
})

# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  harris_data <- read_csv("../data/02-analysis_data/harris_elections_data.csv")
  expect_true(all(!is.na(harris_data)))
})

# Test that 'state' contains only valid US state or territory names
valid_states <- c("Arizona", "California", "Florida", "Georgia", "Iowa", "Maryland", "Massachusetts",
                  "Michigan", "Minesota", "Montana", "Nevada", "New Hampshire", "New Mexico", "New York",
                  "North Carolina", "Ohio", "Pennsylvania", "Tennessee", "Texas", "Virginia", "Wisconsin", "Other")
test_that("'state' contains valid US state names", {
  harris_data <- read_csv("../data/02-analysis_data/harris_elections_data.csv")
  expect_true(all(harris_data$state %in% valid_states))
})

# Test that 'candidate_name' contains only "Kamala Harris" as we intended in the filtering stage
candidate_filter <- c("Kamala Harris")
test_that("'candidate_name' contains only shows Kamala Harris as we filtered", {
  harris_data <- read_csv("../data/02-analysis_data/harris_elections_data.csv")
  expect_true(all(harris_data$candidate_name %in% candidate_filter))
})

# Test that there are no empty strings in 'pollster', 'state', or 'candidate_name' columns
test_that("no empty strings in 'pollster', 'state', or 'candidate_name' columns", {
  harris_data <- read_csv("../data/02-analysis_data/harris_elections_data.csv")
  expect_false(any(harris_data$pollster == "" | harris_data$state == "" | harris_data$candidate_name == ""))
})

# Test for negative numbers in numeric columns
test_that("no negative numbers in numeric columns", {
  harris_data <- read_csv("../data/02-analysis_data/harris_elections_data.csv")
  expect_true(min(harris_data$numeric_grade) >= 0)
  expect_true(min(harris_data$sample_size) >= 0)
  expect_true(min(harris_data$num_harris) >= 0)
})