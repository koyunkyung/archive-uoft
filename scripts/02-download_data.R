#### Preamble ####
# Purpose: Downloads and saves the data from the Spotify API
# Author: Group 20 
# Date: 10 October 2024
# Contact: chenika.bukes@mail.utoronto.ca
# License: MIT
# Pre-requisites: You have saved your spotify API credentials to the environment file. 
# Any other information needed? None


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(spotifyr)

#### Download data ####
radiohead <- get_artist_audio_features("radiohead")
coldplay <- get_artist_audio_features("coldplay")



#### Save data ####
saveRDS(radiohead, "data/01-raw_data/radiohead.rds")
saveRDS(coldplay, "data/01-raw_data/coldplay.rds")

         
