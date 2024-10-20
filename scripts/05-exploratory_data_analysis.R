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


#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)


