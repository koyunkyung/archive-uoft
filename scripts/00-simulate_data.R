#### Preamble ####
# Purpose: Simulates data
# Author: Yunkyung Ko
# Date: 22 September 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(lubridate)

#### Simulate data ####

# Set seed for reproducibility
set.seed(123)

# Define the start and end dates

start_date <- as.Date("2015-01-01")
end_date <- as.Date("2025-12-31")

# Generate a sequence of monthly dates between start_date and end_date
monthly_dates <- seq(from = start_date, to = end_date, by = "month")

# Format dates to "YYYY-MM" without including the day
formatted_dates <- format(monthly_dates, "%Y-%m")

# Generate random Poisson distributed numbers with lambda = 10 for each month
lambda <- 15
poisson_values <- rpois(length(formatted_dates), lambda)

# Create a data frame to hold the results
simulated_data <- data.frame(Date = formatted_dates, Number_of_Outbreaks = poisson_values)

### Write CSV
write_csv(simulated_data, file="data/raw_data/simulated_total.csv")
