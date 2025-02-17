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

## Total Outbreak Counts Reported in Toronto Healthcare Institutions
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
sim_date_total <- data.frame(Date = formatted_dates, Number_of_Outbreaks = poisson_values)

### Write CSV
write_csv(sim_date_total, file = "data/raw_data/simulated_data/simulated_date_total.csv")





## Number of Outbreaks Reported by Setting
# Set seed for reproducibility
set.seed(123)

# Simulated data with random numbers
sim_setting_total <- data.frame(
  Setting = c("Hospital-Acute Care", "Hospital-Chronic Care", "Hospital-Psychiatric", "LTCH", "Retirement Home", "Shelter", "Transitional Care"),
  Count = round(runif(7, min = 1, max = 1000)) # Generate random numbers between 1 and 1000
)
### Write CSV
write_csv(sim_setting_total, file = "data/raw_data/simulated_data/simulated_setting_total.csv")





## Trend of Outbreak Counts by Type
# Set seed for reproducibility
set.seed(123)

## Simulated data for outbreak counts by type and year
years <- 2015:2025

# Generate random outbreak counts for each type of outbreak
respiratory <- round(runif(length(years), min = 200, max = 1000)) # Respiratory outbreaks
enteric <- round(runif(length(years), min = 0, max = 100)) # Enteric outbreaks
other <- round(runif(length(years), min = 0, max = 50)) # Other outbreaks

# Combine data into a dataframe
sim_date_type <- data.frame(
  Year = rep(years, 3),
  Count = c(respiratory, enteric, other),
  Type = factor(rep(c("Respiratory", "Enteric", "Other"), each = length(years)))
)
### Write CSV
write_csv(sim_date_type, file = "data/raw_data/simulated_data/simulated_date_type.csv")




## Annual Respiratory Outbreak Counts by Setting
# Set seed for reproducibility
set.seed(123)

# Define the years and settings
years <- 2015:2025
settings <- c("Hospital-Acute Care", "Hospital-Chronic Care", "Hospital-Psychiatric", "LTCH", "Retirement Home", "Shelter", "Transitional Care")

# Generate random outbreak counts for each setting and year
sim_date_respiratory <- expand.grid(Year = years, Setting = settings)
sim_date_respiratory$Count <- round(runif(nrow(sim_date_respiratory), min = 0, max = 500)) # Random counts between 0 and 500

### Write CSV
write_csv(sim_date_respiratory, file = "data/raw_data/simulated_data/simulated_date_repository.csv")





## Annual Enteric Outbreak Counts by Setting
# Set seed for reproducibility
set.seed(123)

# Define the years and settings
years <- 2015:2025
settings <- c("Hospital-Acute Care", "Hospital-Chronic Care", "Hospital-Psychiatric", "LTCH", "Retirement Home", "Shelter", "Transitional Care")

# Generate random outbreak counts for each setting and year
sim_date_enteric <- expand.grid(Year = years, Setting = settings)
sim_date_enteric$Count <- round(runif(nrow(sim_date_enteric), min = 0, max = 100)) # Random counts between 0 and 100

### Write CSV
write_csv(sim_date_enteric, file = "data/raw_data/simulated_data/simulated_date_enteric.csv")

# Code linting and styling
library(lintr)
library(styler)
style_file(path = "scripts/00-simulate_data.R")
lint(filename = "scripts/00-simulate_data.R")
