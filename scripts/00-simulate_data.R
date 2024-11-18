#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Yunkyung Ko
# Date: 17 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `infant_folder` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(853)


#### Simulate data ####
simulation_data <- tibble(
  dem_momage = sample(18:45, 1000, replace = TRUE), # Mother Age: 18-45
  dem_dadage = sample(18:60, 1000, replace = TRUE), # Father Age: 18-60
  mom_bmi = round(runif(1000, 18, 40), 1), # BMI: 18-40
  mom_notobaco = sample(0:1, 1000, replace = TRUE, prob = c(0.8, 0.2)), # 80% Non-Smoker, 20% Smoker
  mom_noinfec = sample(c(0, 1, 9), 1000, replace = TRUE, prob = c(0.7, 0.2, 0.1)), # No Infection: 70%, True: 20%, Not Reported: 10%
  med_previs = sample(c(1:30, 99), 1000, replace = TRUE, prob = c(rep(0.03, 30), 0.1)), # Prenatal Visits: 1~30 or 99
  med_wic = sample(c("Yes", "No", "U"), 1000, replace = TRUE, prob = c(0.5, 0.4, 0.1)), # WIC: Yes(50%), No(40%), Unknown(10%)
  inft_weight = sample(c(1000:4500, 9999), 1000, replace = TRUE, prob = c(rep(0.001, 3501), 0.01)), # Birth Weight: 1000~4500g, 9999 Not Stated
  inft_gest = sample(c(22:42, 99), 1000, replace = TRUE, prob = c(rep(0.04, 21), 0.05)), # Gestation: 22~42 weeks or 99 unknown
  no_abnorm = sample(c(0, 1, 9), 1000, replace = TRUE, prob = c(0.6, 0.3, 0.1)), # No Abnormal Conditions
  no_congen = sample(c(0, 1, 9), 1000, replace = TRUE, prob = c(0.7, 0.2, 0.1))  # No Congenital Anomalies
)

sim_data_na <- simulation_data %>%
  mutate(
    # outlier handling: convert 'unknown or not reported' into NA
    mom_noinfec = ifelse(mom_noinfec == 9, NA, mom_noinfec),
    med_previs = ifelse(med_previs == 99, NA, med_previs),
    inft_weight = ifelse(inft_weight == 9999, NA, inft_weight),
    inft_gest = ifelse(inft_gest == 99, NA, inft_gest),
    no_abnorm = ifelse(no_abnorm == 9, NA, no_abnorm),
    no_congen = ifelse(no_congen == 9, NA, no_congen),
    # WIC: Yes → 1, No → 0, Unknown → NA
    med_wic = case_when(
      med_wic == "Yes" ~ 1,
      med_wic == "No" ~ 0,
      TRUE ~ NA_real_
    ),
    # mom_notobaco: 1 → 0, 0 → 1
    mom_notobaco = ifelse(mom_notobaco == 1, 0, ifelse(mom_notobaco == 0, 1, NA))
  ) 

sim_data <- sim_data_na %>%
  drop_na()


#### Save data ####
write_csv(sim_data, "data/00-simulated_data/simulated_data.csv")
