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
  select(causative_agent_1, date_outbreak_began) |>
  
  # Rename the column causative_agent_1 to causative_agent
  rename(causative_agent = causative_agent_1) |>
  
  mutate(
    # Convert the date to "YYYY-MM" format
    date_outbreak_began = format(as.Date(date_outbreak_began), "%Y-%m"),
    
    # Extract year and month
    year = substr(date_outbreak_began, 1, 4),
    month = as.numeric(substr(date_outbreak_began, 6, 7)),
    
    # Classify into "YYYY_first_half" or "YYYY_second_half"
    date_of_outbreak = case_when(
      month %in% 1:6 ~ paste0(year, "_begin"),
      month %in% 7:12 ~ paste0(year, "_end")
    )
  ) |>
  
  # Filter out the rows with '2024_second_half'
  filter(date_of_outbreak != "2024_end") |>
  
  select(causative_agent, date_of_outbreak)

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/analysis_data.csv")
