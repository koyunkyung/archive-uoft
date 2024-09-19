#### Preamble ####
# Purpose: Simulates data
# Author: Yunkyung Ko
# Date: 19 September 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####

set.seed(304)
data <- tibble(
  date = seq.Date(from = as.Date('2020-01-01'), by = 'day', length.out = 100), 
  number_of_marriage = rpois(n = 100, lambda = 10)
)

write_csv(data, file="data/raw_data/simulated.csv")
