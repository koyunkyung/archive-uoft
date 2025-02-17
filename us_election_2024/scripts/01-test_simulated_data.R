#### Preamble ####
# Purpose: Tests the structure and validity of the simulated US presidential election polls data. In addition, plot the data to check the overall expected outcomes.
# Author: Yunkyung Ko
# Date: 3 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - The `tidyverse` package must be installed and loaded
# - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `us_election` rproj


#### Workspace setup ####
library(tidyverse)
library(ggplot2)
sim_harris_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("sim_harris_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test the structure and validity of simulated dataset ####
# Check if the dataset has 540 rows
if (nrow(sim_harris_data) == 540) {
  message("Test Passed: The dataset has 540 rows.")
} else {
  stop("Test Failed: The dataset does not have 540 rows.")
}

# Check if the dataset has 8 columns
if (ncol(sim_harris_data) == 8) {
  message("Test Passed: The dataset has 8 columns.")
} else {
  stop("Test Failed: The dataset does not have 8 columns.")
}

# Check if the 'state' column contains valid state names
valid_states <- c("Florida", "Pennsylvania", "Michigan", "Wisconsin", "Arizona", "Texas")
if (all(sim_harris_data$state %in% valid_states)) {
  message("Test Passed: The 'state' column contains only valid state names.")
} else {
  stop("Test Failed: The 'state' column contains invalid state names.")
}

# Check if the 'pollster' column contains valid pollster names
valid_pollsters <- c("YouGov", "RMG Research", "CBS News", "Napolitan News", "Ipsos", "SurveyMonkey", "Other")
if (all(sim_harris_data$pollster %in% valid_pollsters)) {
  message("Test Passed: The 'pollster' column contains only valid pollster names.")
} else {
  stop("Test Failed: The 'pollster' column contains invalid pollster names.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(sim_harris_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'state', 'pollster', and 'candidate_name' columns
if (all(sim_harris_data$state != "" & sim_harris_data$pollster != "" & sim_harris_data$candidate_name != "")) {
  message("Test Passed: There are no empty strings in 'state', 'pollster', or 'candidate_name'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}


#### Plot the simulated data ####
# Generate a plot for Harris over time
sim_harris_time <- ggplot(sim_harris_data, aes(x = date, y = pct)) +
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(y = "Harris Percent", x = "Date", title = "The Percentage of Vote/Support that Harris Received in the Poll.")
ggsave("data/00-simulated_data/test_plots/sim_harris_time.png", sim_harris_time, width = 8, height = 6, dpi = 300)

# Plot by pollster
sim_harris_pollster_a <- # Plot by pollster
  ggplot(sim_harris_data, aes(x = date, y = pct, color = pollster)) +
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(y = "Harris Percent", x = "Date", title = "The Vote that Harris Received in the Poll, by Pollster.") +
  scale_color_manual(values = c(
    "YouGov" = "blue", "RMG Research" = "red", "CBS News" = "green",
    "Napolitan News" = "purple", "Ipsos" = "brown", "SurveyMonkey" = "yellow", "Other" = "grey"
  )) +
  theme(legend.position = "bottom")
ggsave("data/00-simulated_data/test_plots/sim_harris_pollster.png", sim_harris_pollster_a, width = 8, height = 6, dpi = 300)
# Faceted plot by pollster
sim_harris_pollster_b <- ggplot(sim_harris_data, aes(x = date, y = pct)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~pollster) +
  theme_classic() +
  labs(y = "Harris Percent", x = "Date", title = "The Vote that Harris Received in the Poll, by Pollster (Facets)")
ggsave("data/00-simulated_data/test_plots/sim_harris_pollster_facets.png", sim_harris_pollster_b, width = 8, height = 6, dpi = 300)

# Plot by pollscore
sim_harris_pollscore <- ggplot(sim_harris_data, aes(x = date, y = pct, color = pollscore)) +
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(y = "Harris Percent", x = "Date", title = "The Vote that Harris Received in the Poll, by Pollscore") +
  scale_color_viridis_c() +
  theme(legend.position = "bottom")
ggsave("data/00-simulated_data/test_plots/sim_harris_pollscore.png", sim_harris_pollscore, width = 8, height = 6, dpi = 300)

# Plot by state
sim_harris_state_a <-
  ggplot(sim_harris_data, aes(x = date, y = pct, color = state)) +
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(y = "Harris Percent", x = "Date", title = "The Vote that Harris Received in the Poll, by State") +
  scale_color_manual(values = c(
    "Florida" = "blue", "Pennsylvania" = "red", "Michigan" = "green",
    "Wisconsin" = "purple", "Arizona" = "brown", "Texas" = "yellow"
  )) +
  theme(legend.position = "bottom")
ggsave("data/00-simulated_data/test_plots/sim_harris_state.png", sim_harris_state_a, width = 8, height = 6, dpi = 300)
# Faceted plot by pollster
sim_harris_state_b <- ggplot(sim_harris_data, aes(x = date, y = pct)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~state) +
  theme_classic() +
  labs(y = "Harris Percent", x = "Date", title = "The Vote that Harris Received in the Poll, by State (Facets)")
ggsave("data/00-simulated_data/test_plots/sim_harris_state_facets.png", sim_harris_state_b, width = 8, height = 6, dpi = 300)

