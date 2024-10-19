#### Preamble ####
# Purpose: Cleans the raw elections data and selects relevant variables for the analysis
# Author: Yunkyung Ko
# Date: 13 October 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to have downloaded the data.
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_elections_data <- read_csv("data/01-raw_data/raw_elections_data.csv")

cleaned_data <-
  raw_elections_data |>
  janitor::clean_names() |>
  select(pollster_id, pollster, methodology, transparency_score, state, race_id, sample_size, party, answer) |>
  tidyr::drop_na()

#### Save data ####
write_csv(cleaned_data, "data/02-analysis_data/elections_data.csv")
