#### Preamble ####
# Purpose: Tests the structure and validity of the simulated infant health dataset. Shows expected results of the logistic regression model with simulated data.
# Author: Yunkyung Ko
# Date: 23 November 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `infant_health` rproj


#### Workspace setup ####
library(tidyverse)
sim_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("sim_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test dataset structure ####
# Check if the dataset has 671 rows
if (nrow(sim_data) == 671) {
  message("Test Passed: The dataset has 671 rows.")
} else {
  stop("Test Failed: The dataset does not have 671 rows.")
}

# Check if the dataset has 7 columns
if (ncol(sim_data) == 7) {
  message("Test Passed: The dataset has 7 columns.")
} else {
  stop("Test Failed: The dataset does not have 7 columns.")
}


#### Test for missing values ####
# Check if there are any missing values in the dataset
if (all(!is.na(sim_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}


#### Test for outliers (unknown or unreported values) ####
# Check if apgar5 contains any outlier values
if ("apgar5" %in% colnames(sim_data)) {
  if (any(sim_data$apgar5 == 99, na.rm = TRUE)) {
    print(paste("Test Failed: The variable apgar5 contains outliers (value:", outlier_code, ")."))
  } else if (all(sim_data$apgar5 >= 0 & sim_data$apgar5 <= 10, na.rm = TRUE)) {
    print("Test Passed: The variable apgar5 contains no outliers and is within the range 0 to 10.")
  } else {
    print("Test Failed: The variable apgar5 contains values outside the range 0 to 10.")
  }
} else {
  print("Test Failed: The variable apgar5 is not in the dataset.")
}

#### Test for the type of variables ####
# Define binary variables
binary_variables <- c("indc", "augmt", "ster", "antb", "chor", "anes")
# Test binary variables
binary_test_results <- lapply(binary_variables, function(var) {
  if (var %in% colnames(sim_data)) {
    # Check if all values are 0 or 1
    if (all(sim_data[[var]] %in% c(0, 1), na.rm = TRUE)) {
      return(paste("Test Passed: The variable", var, "contains only binary values (0 or 1)."))
    } else {
      return(paste("Test Failed: The variable", var, "contains non-binary values."))
    }
  } else {
    return(paste("Test Failed: The variable", var, "is not in the dataset."))
  }
})
# Print binary variable test results
cat(paste(binary_test_results, collapse = "\n"), "\n")

# Test if the 'apgar5' variable is numeric
if ("apgar5" %in% colnames(sim_data)) {
  # Check if the variable is numeric
  if (is.numeric(sim_data[["apgar5"]])) {
    print(paste("Test Passed: The variable", "apgar5", "is numeric."))
  } else {
    print(paste("Test Failed: The variable", "apgar5", "is not numeric."))
  }
} else {
  print(paste("Test Failed: The variable", "apgar5", "is not in the dataset."))
}




### Test for expected results with simulation data ###
library(ggplot2)
library(dplyr)
library(reshape2)

# create the variable for counting the number of treatment the infant received during delivery and labor
sim_data <- sim_data %>%
  mutate(
    drug_count = rowSums(select(., c(indc, augmt, ster, antb, chor, anes)) == 1, na.rm = TRUE)
  )

# Graph 1: Relationship between Number of Treatments Used and APGAR Score
simm_data <- sim_data %>%
  mutate(
    drug_count = rowSums(select(., c(indc, augmt, ster, antb, chor, anes)) == 1, na.rm = TRUE)
  )

summary_data_s <- simm_data %>%
  group_by(drug_count) %>%
  summarise(
    mean_apgar5 = mean(apgar5),
    sd_apgar5 = sd(apgar5)
  )

num_drugs <- ggplot(summary_data_s, aes(x = factor(drug_count), y = mean_apgar5)) +
  geom_bar(
    stat = "identity",
    width = 0.5,  # Adjust width for thinner bars
    fill = "skyblue",
    color = "black",
    alpha = 0.7
  ) +
  geom_errorbar(
    aes(ymin = mean_apgar5 - sd_apgar5, ymax = mean_apgar5 + sd_apgar5),
    width = 0.2,  # Width of error bars remains the same
    color = "blue"
  ) +
  geom_text(
    aes(label = round(mean_apgar5, 1)),
    vjust = -0.5,
    size = 4,
    color = "black"
  ) +
  labs(
    title = "Relationship between the number of treatments used during labor/delivery and the APGAR5 score",
    x = "Number of Treatments During Labor and Delivery",
    y = "Mean of APGAR5 Score"
  ) +
  scale_y_continuous(
    limits = c(0, max(summary_data_s$mean_apgar5 + summary_data_s$sd_apgar5) + 1),
    breaks = seq(0, 10, by = 1)
  ) +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 13),
    plot.title = element_text(hjust = 0.5, size = 11.5, face = "bold"),  # Center and format title
    plot.margin = margin(10, 10, 10, 10)  # Add spacing around the plot
  )
# Save the plot in .png file
ggsave(filename = "data/00-simulated_data/simulated_results/num_drugs.png", plot = num_drugs, width = 8, height = 6, dpi = 300)

# Graph 2: Heatmap for Characteristics of Labor/Delivery and APGAR Scores
# Reshape data for the heatmap
heatmap_data <- sim_data %>%
  pivot_longer(
    cols = c(indc, augmt, ster, antb, chor, anes), 
    names_to = "Drug_Usage", 
    values_to = "Usage"
  ) %>%
  filter(Usage == 1) %>%  # Keep rows where drug usage is "Yes" (1)
  group_by(Drug_Usage, apgar5) %>%
  summarise(Count = n(), .groups = "drop") %>%
  pivot_wider(names_from = apgar5, values_from = Count, values_fill = 0)

# Convert the reshaped data back to long format for ggplot
heatmap_long <- heatmap_data %>%
  pivot_longer(-Drug_Usage, names_to = "APGAR5", values_to = "Count") %>%
  mutate(APGAR5 = as.numeric(APGAR5))

# Create heatmap
# Create a mapping of custom labels for drug usage categories
custom_labels <- c(
  indc = "Induction of Labor",
  augmt = "Augmentation of Labor",
  ster = "Steroids",
  antb = "Antibiotics",
  chor = "Chorioamnionitis",
  anes = "Anesthesia"
)
treat_scores <- ggplot(heatmap_long, aes(x = APGAR5, y = Drug_Usage, fill = Count)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "lightblue", high = "blue", name = "Count of Yes Responses") +
  scale_y_discrete(labels = custom_labels) +  # Apply custom labels to y-axis (Drug Usage Categories)
  labs(
    title = "Heatmap: Drug Usage Characteristics and APGAR Scores",
    x = "APGAR5 Score (0 to 10)",
    y = "Treatments Categories During Delivery and Labor"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white"),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),  # Angle and align x-axis text
    axis.text.y = element_text(size = 12),  # Increase y-axis text size
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Center and format title
    plot.margin = margin(10, 10, 10, 10)  # Add spacing around the plot
  )
# Save the plot to a .png file
ggsave(
  filename = "data/00-simulated_data/simulated_results/treat_scores.png",
  plot = treat_scores,
  width = 10,  # Increase width for better label spacing
  height = 8,  # Increase height for better readability
  dpi = 300
)


# Graph 3: APGAR Score Distribution for Drug Usage
# Induction of Labor
# Filter data for Induction of Labor (indc == 1)
indc_data <- sim_data %>% filter(indc == 1)
# Plot APGAR5 score distribution for Induction of Labor
indc_scores <- ggplot(indc_data, aes(x = apgar5)) +
  geom_histogram(aes(y = after_stat(count)), binwidth = 1, color = "grey", fill = "skyblue", alpha = 0.7) +
  geom_density(aes(y = after_stat(count)), color = "black", size = 1, adjust = 1) +
  labs(
    title = "APGAR5 Score Distribution for Usage of Induction of Labor",
    x = "Five-Minute APGAR Score",
    y = "Count of Responses"
  ) +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white"),
    axis.text.x = element_text(hjust = 1, vjust = 1),  # Angle and align x-axis text
    axis.text.y = element_text(size = 12),  # Increase y-axis text size
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Center and format title
    plot.margin = margin(10, 10, 10, 10))  # Add spacing around the plot
# Save the plot in .png file
ggsave(filename = "data/00-simulated_data/simulated_results/indc_scores.png", plot = indc_scores, width = 8, height = 6, dpi = 300)


# Augmentation of Labor
# Filter data for Augmentation of Labor
augmt_data <- sim_data %>% filter(augmt == 1)
# Plot APGAR5 score distribution for Augmentation of Labor
augmt_scores <- ggplot(augmt_data, aes(x = apgar5)) +
  geom_histogram(aes(y = after_stat(count)), binwidth = 1, color = "grey", fill = "skyblue", alpha = 0.7) +
  geom_density(aes(y = after_stat(count)), color = "black", size = 1, adjust = 1) +
  labs(
    title = "APGAR5 Score Distribution for Usage of Augmentation of Labor",
    x = "Five-Minute APGAR Score",
    y = "Count of Responses"
  ) +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white"),
    axis.text.x = element_text(hjust = 1, vjust = 1),  # Angle and align x-axis text
    axis.text.y = element_text(size = 12),  # Increase y-axis text size
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Center and format title
    plot.margin = margin(10, 10, 10, 10))  # Add spacing around the plot
# Save the plot in .png file
ggsave(filename = "data/00-simulated_data/simulated_results/augmt_scores.png", plot = augmt_scores, width = 8, height = 6, dpi = 300)


# Steroids
# Filter data for Steroids
ster_data <- sim_data %>% filter(ster == 1)
# Plot APGAR5 score distribution for Steroids
ster_scores <- ggplot(ster_data, aes(x = apgar5)) +
  geom_histogram(aes(y = after_stat(count)), binwidth = 1, color = "grey", fill = "skyblue", alpha = 0.7) +
  geom_density(aes(y = after_stat(count)), color = "black", size = 1, adjust = 1) +
  labs(
    title = "APGAR5 Score Distribution for Usage of Steroids",
    x = "Five-Minute APGAR Score",
    y = "Count of Responses"
  ) +
  theme_minimal()  +
  theme(
    plot.background = element_rect(fill = "white"),
    axis.text.x = element_text(hjust = 1, vjust = 1),  # Angle and align x-axis text
    axis.text.y = element_text(size = 12),  # Increase y-axis text size
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Center and format title
    plot.margin = margin(10, 10, 10, 10))  # Add spacing around the plot
# Save the plot in .png file
ggsave(filename = "data/00-simulated_data/simulated_results/ster_scores.png", plot = ster_scores, width = 8, height = 6, dpi = 300)


# Antibiotics
# Filter data for Antibiotics
antb_data <- sim_data %>% filter(antb == 1)
# Plot APGAR5 score distribution for Antibiotics
antb_scores <- ggplot(antb_data, aes(x = apgar5)) +
  geom_histogram(aes(y = after_stat(count)), binwidth = 1, color = "grey", fill = "skyblue", alpha = 0.7) +
  geom_density(aes(y = after_stat(count)), color = "black", size = 1, adjust = 1) +
  labs(
    title = "APGAR5 Score Distribution for Usage of Antibiotics",
    x = "Five-Minute APGAR Score",
    y = "Count of Responses"
  ) +
  theme_minimal()  +
  theme(
    plot.background = element_rect(fill = "white"),
    axis.text.x = element_text(hjust = 1, vjust = 1),  # Angle and align x-axis text
    axis.text.y = element_text(size = 12),  # Increase y-axis text size
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Center and format title
    plot.margin = margin(10, 10, 10, 10))  # Add spacing around the plot
# Save the plot in .png file
ggsave(filename = "data/00-simulated_data/simulated_results/antb_scores.png", plot = antb_scores, width = 8, height = 6, dpi = 300)


# Chorioamnionitis
# Filter data for Chorioamnionitis
chor_data <- sim_data %>% filter(chor == 1)
# Plot APGAR5 score distribution for Chorioamnionitis
chor_scores <- ggplot(chor_data, aes(x = apgar5)) +
  geom_histogram(aes(y = after_stat(count)), binwidth = 1, color = "grey", fill = "skyblue", alpha = 0.7) +
  geom_density(aes(y = after_stat(count)), color = "black", size = 1, adjust = 1) +
  labs(
    title = "APGAR5 Score Distribution for Usage of Chorioamnionitis",
    x = "Five-Minute APGAR Score",
    y = "Count of Responses"
  ) +
  theme_minimal()  +
  theme(
    plot.background = element_rect(fill = "white"),
    axis.text.x = element_text(hjust = 1, vjust = 1),  # Angle and align x-axis text
    axis.text.y = element_text(size = 12),  # Increase y-axis text size
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Center and format title
    plot.margin = margin(10, 10, 10, 10))  # Add spacing around the plot
# Save the plot in .png file
ggsave(filename = "data/00-simulated_data/simulated_results/chor_scores.png", plot = chor_scores, width = 8, height = 6, dpi = 300)




# Anesthesia
# Filter data for Anesthesia
anes_data <- sim_data %>% filter(anes == 1)
# Plot APGAR5 score distribution for Anesthesia
anes_scores <- ggplot(anes_data, aes(x = apgar5)) +
  geom_histogram(aes(y = after_stat(count)), binwidth = 1, color = "grey", fill = "skyblue", alpha = 0.7) +
  geom_density(aes(y = after_stat(count)), color = "black", size = 1, adjust = 1) +
  labs(
    title = "APGAR5 Score Distribution for Usage of Anesthesia",
    x = "Five-Minute APGAR Score",
    y = "Count of Responses"
  ) +
  theme_minimal()  +
  theme(
    plot.background = element_rect(fill = "white"),
    axis.text.x = element_text(hjust = 1, vjust = 1),  # Angle and align x-axis text
    axis.text.y = element_text(size = 12),  # Increase y-axis text size
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Center and format title
    plot.margin = margin(10, 10, 10, 10))  # Add spacing around the plot
# Save the plot in .png file
ggsave(filename = "data/00-simulated_data/simulated_results/anes_scores.png", plot = anes_scores, width = 8, height = 6, dpi = 300)
