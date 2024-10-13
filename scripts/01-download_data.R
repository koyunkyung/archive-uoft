#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Yunkyung Ko
# Date: 22 September 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(opendatatoronto)

#### Download data ####
package <- show_package("80ce0bd7-adb2-4568-b9d7-712f6ba38e4e")
resources <- list_package_resources("80ce0bd7-adb2-4568-b9d7-712f6ba38e4e")
datastore_resources <- filter(resources, tolower(format) %in% c("csv", "geojson"))

resources_list <- filter(datastore_resources, row_number() %in% 1:9)

datasets <- list()
for (i in seq_len(nrow(resources_list))) {
  datasets[[i]] <- get_resource(resources_list[i, ])
}

#### Save data ####
# change datasets to whatever name you assigned when you downloaded it.
combined_data <- bind_rows(datasets)
write_csv(combined_data, "data/raw_data/raw_data.csv")

# Code linting and styling
library(lintr)
library(styler)
style_file(path = "scripts/01-download_data.R")
lint(filename = "scripts/01-download_data.R")