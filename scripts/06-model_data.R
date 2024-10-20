#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Yunkyung Ko
# Date: 20 October 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
harris_data <- read_csv("data/02-analysis_data/harris_elections_data.csv")

### Model data ####
# Model 1: pct as a function of date
model_date <- stan_glm(
  formula = pct ~ end_date,
  data = harris_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)

# Model 2: pct as a function of date and pollster
model_date_pollster <- stan_glm(
  formula = pct ~ end_date + pollster,
  data = harris_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)


#### Save model ####
saveRDS(
  model_date,
  file = "models/model_date.rds"
)

saveRDS(
  model_date_pollster,
  file = "models/model_date_pollster.rds"
)

