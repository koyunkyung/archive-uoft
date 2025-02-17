#### Preamble ####
# Purpose: Downloads and saves the data from the FiveThirtyEight's 2024 US Presidential Election Polls (National)
# Author: Yunkyung Ko
# Date: 3 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)

#### Download data ####
raw_elections_data <- read_csv(file = "https://projects.fivethirtyeight.com/polls/data/president_polls.csv")

#### Save data ####
write_csv(raw_elections_data, "data/01-raw_data/raw_elections_data.csv")
