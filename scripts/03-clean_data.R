#### Preamble ####
# Purpose: Selects relevant variables for analysis and removes the outliers(unknown or unreported).
# Author: Yunkyung Ko
# Date: 17 November 2024
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
  select(mager, fagecomb, bmi, f_tobaco, no_infec, previs, wic, dbwt, combgest, no_abnorm, no_congen) |>
  
  # handling outliers by converting 'unknown or not reported' values to NA
  mutate(
    no_infec = ifelse(no_infec == 9, NA, no_infec),
    previs = ifelse(previs == 99, NA, previs),
    wic = ifelse(wic == "Y", "Yes", ifelse(wic == "N", "No", NA)),
    dbwt = ifelse(dbwt == 9999, NA, dbwt),
    combgest = ifelse(combgest == 99, NA, combgest),
    no_abnorm = ifelse(no_abnorm == 9, NA, no_abnorm),
    no_congen = ifelse(no_congen == 9, NA, no_congen)
  ) |>
  
  mutate(
    # converting categorical text values into binary numerical values
    wic = case_when(
      wic == "Yes" ~ 1,
      wic == "No" ~ 0,
      TRUE ~ NA_real_),
    
    # reversing binary values in the variable so that healthier outcomes are represented by values closer to 1
    f_tobaco = ifelse(f_tobaco == 1, 0, ifelse(f_tobaco == 0, 1, NA))
  ) |>
  
  rename(
    dem_momage = mager,
    dem_dadage = fagecomb,
    mom_bmi = bmi,
    mom_notobaco = f_tobaco,
    mom_noinfec = no_infec,
    med_previs = previs,
    med_wic = wic,
    inft_weight = dbwt,
    inft_gest = combgest,
  )

infant_health <- infant_health_na %>%
  drop_na()

#### Save data ####
write_csv(infant_health, "data/02-analysis_data/infant_health.csv")
write_parquet(infant_health, "data/02-analysis_data/infant_health.parquet")
