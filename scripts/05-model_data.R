#### Preamble ####
# Purpose: Regression Models for predicting the percentage of supportive polls
# Author: Yunkyung Ko
# Date: 3 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to have downloaded the data.
# Any other information needed? None


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

# Bayesian Model 1: random intercept for pollster
# Change 'pollster' and 'state' to factor variables
harris_data <- harris_data |>
  mutate(
    pollster = factor(pollster),
    state = factor(state)
  )
# Specify priors
priors <- normal(0, 2.5, autoscale = TRUE)

model_formula_1 <- cbind(num_harris, sample_size - num_harris) ~ (1 | pollster)
bayesian_model_1 <- stan_glmer(
  formula = model_formula_1,
  data = harris_data,
  family = binomial(link = "logit"),
  prior = priors,
  prior_intercept = priors,
  seed = 123,
  cores = 4,
  adapt_delta = 0.95
)

# Bayesian Model 2: random intercepts for pollster and state
model_formula_2 <- cbind(num_harris, sample_size - num_harris) ~ (1 | pollster) + (1 | state)

bayesian_model_2 <- stan_glmer(
  formula = model_formula_2,
  data = harris_data,
  family = binomial(link = "logit"),
  prior = priors,
  prior_intercept = priors,
  seed = 123,
  cores = 4,
  adapt_delta = 0.95
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

saveRDS(
  bayesian_model_1,
  file = "models/bayesian_model_1.rds"
)

saveRDS(
  bayesian_model_2,
  file = "models/bayesian_model_2.rds"
)
