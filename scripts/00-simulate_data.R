#### Preamble ####
# Purpose: Simulates a dataset of US election polling data
# Author: Yunkyung Ko
# Date: 19 October 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `us_election` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(853)

#### Simulate polling data for Kamala Harris ####
# Simulate poll data
sim_poll_data <- tibble(
  poll_id = 1:1000,
  pollster = sample(c("YouGov", "RMG Research", "CBS News", "Napolitan News", "Ipsos", "SurveyMonkey", "Other"), size = 1000, replace = TRUE),
  numeric_grade = runif(1000, 2.7, 5.0), # Pollster quality between 2.7 and 5.0
  pollscore = runif(1000, -1.5, 2.5),
  candidate_name = sample(c("Kamala Harris", "Donald Trump"), size = 1000, replace = TRUE, prob = c(0.6, 0.4)),
  pct = jitter(50 + rnorm(1000, mean = 0, sd = 5), amount = 2),
  state = sample(c("Florida", "Pennsylvania", "Michigan", "Wisconsin", "Arizona", "Texas"), size = 1000, replace = TRUE),
  date = as.Date("2024-07-01") + sample(0:90, 1000, replace = TRUE)
)

# Filter Harris data and keep only high-quality pollsters
sim_harris_data <- sim_poll_data %>%
  filter(candidate_name == "Kamala Harris", numeric_grade >= 3.0)

#### Save data ####
write_csv(sim_harris_data, "data/00-simulated_data/simulated_data.csv")
