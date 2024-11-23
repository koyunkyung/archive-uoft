#### Preamble ####
# Purpose: Selects relevant variables for analysis and removes the outliers(unknown or unreported).
# Author: Yunkyung Ko
# Date: 23 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites:
  # - The `tidyverse`, `arrow` package must be installed and loaded
  # - 02-download_data.R must have been run
# Any other information needed? Make sure you are in the `infant_health` rproj

#### Workspace setup ####
library(data.table)
library(tidyverse)
library(arrow)

#### Clean data ####
raw_data <- fread("data/01-raw_data/infant_data.csv")

infant_health_na <-
  raw_data |>
  janitor::clean_names() |>
  
  # select relevant variables for analysis
  select(ld_indl, ld_augm, ld_ster, ld_antb, ld_chor, ld_anes, apgar5) |>
  
  # handling outliers by converting 'unknown or not reported' values to NA
  mutate(
    apgar5 = ifelse(apgar5 == 99, NA, apgar5)
  ) |>
  
  mutate(
    # converting categorical text values into binary numerical values
    across(c(ld_indl, ld_augm, ld_ster, ld_antb, ld_chor, ld_anes), ~ case_when(
      . == "Y" ~ 1,
      . == "N" ~ 0,
      . == "U" ~ NA_real_,
      TRUE ~ as.numeric(.)
    ))) |>
  
  rename(
    indc = ld_indl,
    augmt = ld_augm,
    ster = ld_ster,
    antb = ld_antb,
    chor = ld_chor,
    anes = ld_anes
  )

infant_health <- infant_health_na %>%
  drop_na()

# Define the desired sample size per `apgar5` score
# You can use the minimum count across groups or specify a fixed number
desired_sample_size <- 2000  # Adjust this based on your needs

# Stratified random sampling
balanced_data <- infant_health %>%
  group_by(apgar5) %>%
  sample_n(size = min(desired_sample_size, n()), replace = FALSE) %>%  # Ensure no oversampling
  ungroup()

# Convert the columns into factor so that they could be used for random forest prediction
balanced_data <- balanced_data %>%
  mutate(across(c("indc", "augmt", "ster", "antb", "chor", "anes"), ~ as.factor(.)))

#### Save data ####
write_csv(infant_health, "data/02-analysis_data/infant_health.csv")
write_parquet(infant_health, "data/02-analysis_data/infant_health.parquet")

write_csv(balanced_data, "data/02-analysis_data/infant_balanced.csv")
write_parquet(balanced_data, "data/02-analysis_data/infant_balanced.parquet")
