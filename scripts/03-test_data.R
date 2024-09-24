#### Preamble ####
# Purpose: Sanity check of the data
# Author: Yunkyung Ko
# Date: 22 September 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to have simulated data
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)

#### Test data ####
data <- read_csv("data/raw_data/simulated.csv")

# Test for negative numbers
data$Number_of_Outbreaks |> min() >= 0

# Test for NAs
all(is.na(data$Number_of_Outbreaks |> min() >= 0))