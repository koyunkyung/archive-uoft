#### Preamble ####
# Purpose: Sanity check of the data, Hypotheis verification of how the simulated data would unfold
# Author: Yunkyung Ko
# Date: 22 September 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to have simulated data
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)


#### Test data ####
date_total <- read_csv("data/raw_data/simulated_data/simulated_date_total.csv")
# Test for negative numbers
date_total$Number_of_Outbreaks |> min() >= 0
# Test for NAs
all(is.na(date_total$Number_of_Outbreaks |> min() >= 0))

# Create the bar plot
p <- ggplot(date_total, aes(x = factor(Date), y = Number_of_Outbreaks)) +
  geom_bar(stat = "identity", fill = "black") +
  labs(title = "Total Outbreak Counts (Simulation)",
       x = "Date",
       y = "Number of Outbreaks Reported") +
  theme_minimal()

# Save the plot as a PNG file
ggsave("data/raw_data/simulated_results/simulated_total_outbreak_count.png", plot = p, width = 10, height = 8, dpi = 300)




#### Test data ####
setting_total <- read_csv("data/raw_data/simulated_data/simulated_setting_total.csv")
# Test for negative numbers
setting_total$Count |> min() >= 0
# Test for NAs
all(is.na(setting_total$Count |> min() >= 0))

# Create a pie chart
p <- ggplot(setting_total, aes(x = "", y = Count, fill = Setting)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  labs(title = "Outbreak Counts by Setting (Simulation)", fill = "Outbreak Setting") +
  theme_void() +
  scale_fill_manual(values = c("#d3a9d3", "#a455a4", "#b3b3b3", "#a2d6f9", "#b6f5d3", "#963232", "#000000"))

# Save the plot as a PNG file
ggsave("data/raw_data/simulated_results/simulated_outbreaks_by_setting.png", plot = p, width = 10, height = 8, dpi = 300)






#### Test data ####
date_type <- read_csv("data/raw_data/simulated_data/simulated_date_type.csv")
# Test for negative numbers
date_type$Count |> min() >= 0
# Test for NAs
all(is.na(date_type$Count |> min() >= 0))

# Create the line plot
p <- ggplot(date_type, aes(x = Year, y = Count, color = Type, group = Type)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "Outbreak Counts by Type (Simulation)",
       x = "Year",
       y = "Outbreak Count",
       color = "Type of Outbreak") +
  scale_color_manual(values = c("Respiratory" = "red", "Enteric" = "blue", "Other" = "black")) +
  theme_minimal()

# Save the plot as a PNG file
ggsave("data/raw_data/simulated_results/simulated_outbreaks_by_type.png", plot = p, width = 10, height = 8, dpi = 300)





#### Test data ####
date_repository <- read_csv("data/raw_data/simulated_data/simulated_date_repository.csv")
# Test for negative numbers
date_repository$Count |> min() >= 0
# Test for NAs
all(is.na(date_repository$Count |> min() >= 0))

# Create the stacked bar chart
p <- ggplot(date_repository, aes(x = Year, y = Count, fill = Setting)) +
  geom_bar(stat = "identity") +
  labs(title = "Respiratory Outbreak Counts by Setting (Simulation)",
       x = "Year",
       y = "Outbreak Count",
       fill = "Outbreak Setting") +
  scale_fill_manual(values = c("#d3a9d3", "#a455a4", "#b3b3b3", "#a2d6f9", "#b6f5d3", "#963232", "#000000")) +
  theme_minimal()

# Save the plot as a PNG file
ggsave("data/raw_data/simulated_results/simulated_respiratory_by_setting.png", plot = p, width = 10, height = 8, dpi = 300)





#### Test data ####
date_enteric <- read_csv("data/raw_data/simulated_data/simulated_date_enteric.csv")
# Test for negative numbers
date_enteric$Count |> min() >= 0
# Test for NAs
all(is.na(date_enteric$Count |> min() >= 0))

# Create the stacked bar chart
p<- ggplot(date_enteric, aes(x = Year, y = Count, fill = Setting)) +
  geom_bar(stat = "identity") +
  labs(title = "Enteric Outbreak Counts by Setting (Simulation)",
       x = "Year",
       y = "Outbreak Count",
       fill = "Outbreak Setting") +
  scale_fill_manual(values = c("#d3a9d3", "#a455a4", "#b3b3b3", "#a2d6f9", "#b6f5d3", "#963232", "#000000")) +
  theme_minimal()

# Save the plot as a PNG file
ggsave("data/raw_data/simulated_results/simulated_enteric_by_setting.png", plot = p, width = 10, height = 8, dpi = 300)


