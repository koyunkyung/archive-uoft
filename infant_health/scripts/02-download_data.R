#### Preamble ####
# Purpose: Downloads and saves the data from https://www.cdc.gov/nchs/nvss/linked-birth.htm
# Author: Yunkyung Ko
# Date: 17 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `readr` package must be installed
# Any other information needed? Make sure you are in the `infant_health` rproj


#### Workspace setup ####
library(data.table)
library(arrow)
library(readr)


#### Download data ####
options(timeout = 2000)
raw_data <- fread("https://data.nber.org/nvss/natality/csv/2023/natality2023us.csv")


#### Save the processed data ####
write_csv(raw_data, "data/01-raw_data/infant_data.csv")
write_parquet(raw_data, "data/01-raw_data/infant_data.parquet")
