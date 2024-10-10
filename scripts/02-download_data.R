#### Preamble ####
# Purpose: Downloads and saves the data from https://open.spotify.com/
# Author: Yunkyung Ko
# Date: 10 October 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(spotifyr)

#### Download data ####
radiohead <- get_artist_audio_features("radiohead")
the_national <- get_artist_audio_features("the national")


#### Save data ####
saveRDS(radiohead, "data/01-raw_data/radiohead.rds")
         
