#### Preamble ####
# Purpose: Cleans the raw elections data and filters high-quality polls data
# Author: Yunkyung Ko
# Date: 19 October 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to have downloaded the data.
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
# Read in the data and clean variable names
raw_elections_data <- read_csv("data/01-raw_data/raw_elections_data.csv")
elections_data <-
  raw_elections_data |>
  janitor::clean_names() |>
  select(pollster, numeric_grade, pollscore, state, end_date, candidate_name, sample_size, pct) |>
  tidyr::drop_na() |>
  mutate(
    state = if_else(is.na(state), "National", state) # Handle missing states as "National"
  ) |>
  group_by(state) |>
  mutate(
    state_count = n() # Count the number of polls per state
  ) |>
  ungroup() |>
  mutate(
    state = if_else(state_count < 60, "Other", state) # Assign "Other" for states with fewer than 60 polls
  ) |>
  select(-state_count) # Remove the 'state_count' column

# Remove outliers (pct values greater than 100 or less than 0)
elections_data <- elections_data |>
  filter(pct >= 0 & pct <= 100)

# Filter data to Harris estimates based on high-quality polls after she declared
harris_data <-
  elections_data |>
  filter(
    candidate_name == "Kamala Harris",
    numeric_grade >= 2.7 # Need to investigate this choice - come back and fix.
  ) |>
  mutate(
    state = if_else(is.na(state), "National", state),
    end_date = mdy(end_date)
  ) |>
  filter(end_date >= as.Date("2024-07-21")) |> # When Harris declared
  mutate(
    num_harris = round((pct / 100) * sample_size, 0) # Need number not percent for some models
  ) |>
  group_by(pollster) |>
  filter(n() > 30) |> # Filter for pollsters with more than 35 polls
  ungroup()  |>
  filter(pct >= 0 & pct <= 100)


#### Save data ####
write_csv(elections_data, "data/02-analysis_data/elections_data.csv")
write_csv(harris_data, "data/02-analysis_data/harris_elections_data.csv")
