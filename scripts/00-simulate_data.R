#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Yunkyung Ko
# Date: 18 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `infant_folder` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(853)


#### Simulate data ####
# Generate 1000 samples for each variable
simulation_data <- data.frame(
  indc = sample(c("Y", "N", "U"), size = 1000, replace = TRUE, prob = c(0.3, 0.6, 0.1)),  # Induction of labor
  augmt = sample(c("Y", "N", "U"), size = 1000, replace = TRUE, prob = c(0.2, 0.7, 0.1)),  # Augmentation of labor
  ster = sample(c("Y", "N", "U"), size = 1000, replace = TRUE, prob = c(0.15, 0.8, 0.05)), # Steroids
  antb = sample(c("Y", "N", "U"), size = 1000, replace = TRUE, prob = c(0.1, 0.85, 0.05)), # Antibiotics
  chor = sample(c("Y", "N", "U"), size = 1000, replace = TRUE, prob = c(0.05, 0.9, 0.05)), # Chorioamnionitis
  anes = sample(c("Y", "N", "U"), size = 1000, replace = TRUE, prob = c(0.4, 0.55, 0.05)), # Anesthesia
  apgar5 = sample(c(0:10, 99), size = 1000, replace = TRUE, 
                  prob = c(0.01, 0.02, 0.02, 0.02, 0.05, 0.05, 0.1, 0.1, 0.2, 0.25, 0.15, 0.02)) # Five Minute APGAR Score
)

sim_data <- 
  simulation_data |>
  # handling outliers by converting 'unknown or not reported' values to NA
  mutate(
    apgar5 = ifelse(apgar5 == 99, NA, apgar5)
  ) |>
  
  # converting categorical text values into binary numerical values
  mutate(
    across(c(indc, augmt, ster, antb, chor, anes), ~ case_when(
      . == "Y" ~ 1,
      . == "N" ~ 0,
      . == "U" ~ NA_real_,
      TRUE ~ NA_real_
    )))

sim_data <- sim_data %>%
  drop_na()

#### Save data ####
write_csv(sim_data, "data/00-simulated_data/simulated_data.csv")
