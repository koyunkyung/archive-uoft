#### Preamble ####
# Purpose: Cleans the raw healthcare data into an analysis dataset
# Author: Yunkyung Ko
# Date: 22 September 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to have downloaded the data.
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_data <- read_csv("data/raw_data/raw_data.csv")

cleaned_data <- raw_data |>
  janitor::clean_names() |>
  select(outbreak_setting, type_of_outbreak, date_outbreak_began) |>
  mutate(
    # Convert the date to "YYYY-MM" format
    date = format(as.Date(date_outbreak_began), "%Y-%m"),
    # Extract year and month
    year = substr(date_outbreak_began, 1, 4),
    month = as.numeric(substr(date_outbreak_began, 6, 7)),
  )

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/analysis_data.csv")

# Code linting and styling
library(lintr)
library(styler)
style_file(path = "scripts/02-data_cleaning.R")
lint(filename = "scripts/02-data_cleaning.R")