#### Preamble ####
# Purpose: Tests the structure and validity of the simulated infant health dataset. Shows expected results of the logistic regression model with simulated data.
# Author: Yunkyung Ko
# Date: 17 November 2024
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

# Check if the dataset has 584 rows
if (nrow(sim_data) == 584) {
  message("Test Passed: The dataset has 584 rows.")
} else {
  stop("Test Failed: The dataset does not have 584 rows.")
}

# Check if the dataset has 11 columns
if (ncol(sim_data) == 11) {
  message("Test Passed: The dataset has 11 columns.")
} else {
  stop("Test Failed: The dataset does not have 11 columns.")
}


#### Test for missing values ####

# Check if there are any missing values in the dataset
if (all(!is.na(sim_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}


#### Test for outliers (unknown or unreported values) ####

# Define expected outlier codes for each variable
outlier_codes <- list(
  mom_noinfec = 9,
  med_previs = 99,
  inft_weight = 9999,
  inft_gest = 99,
  no_abnorm = 9,
  no_congen = 9
)

# Check for outliers in each variable
outlier_results <- lapply(names(outlier_codes), function(var) {
  if (var %in% colnames(sim_data)) {
    if (any(sim_data[[var]] == outlier_codes[[var]], na.rm = TRUE)) {
      return(paste("Test Failed: The variable", var, "contains outliers (value:", outlier_codes[[var]], ")."))
    } else {
      return(paste("Test Passed: The variable", var, "contains no outliers."))
    }
  } else {
    return(paste("Test Failed: The variable", var, "is not in the dataset."))
  }
})


#### Test if values fall within defined ranges ####

# Define the expected ranges for each variable
expected_ranges <- list(
  dem_momage = c(18, 45),    # Mother Age: 18-45
  dem_dadage = c(18, 60),    # Father Age: 18-60
  mom_bmi = c(18, 40),       # BMI: 18-40
  med_previs = c(1, 30),     # Prenatal Visits: 1-30
  inft_weight = c(1000, 4500), # Birth Weight: 1000-4500
  inft_gest = c(22, 42)    # Gestation: 22-42 weeks
)

# Initialize a list to store test results
range_results <- lapply(names(expected_ranges), function(var) {
  if (var %in% colnames(sim_data)) {
    # Check if all values are within the defined range
    range <- expected_ranges[[var]]
    if (all(sim_data[[var]] >= range[1] & sim_data[[var]] <= range[2], na.rm = TRUE)) {
      return(paste("Test Passed: All values of", var, "are within the range", range[1], "to", range[2], "."))
    } else {
      return(paste("Test Failed: The variable", var, "has values outside the range", range[1], "to", range[2], "."))
    }
  } else {
    return(paste("Test Failed: The variable", var, "is not in the dataset."))
  }
})


# Print range test results
cat(paste(range_results, collapse = "\n"), "\n")
# Print outlier test results
cat(paste(outlier_results, collapse = "\n"), "\n")



# Define binary variables
binary_variables <- c("mom_notobaco", "mom_noinfec", "med_wic", "no_abnorm", "no_congen")

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



### Test for expected results of the linear regression model with simulation data ###

library(broom)  # For extracting model summaries
library(pROC)   # For ROC curve and AUC

logit_model1 <- glm(no_abnorm ~ dem_momage + dem_dadage + mom_bmi + mom_notobaco + 
                     mom_noinfec + med_previs + med_wic + inft_weight + inft_gest,
                   data = sim_data, family = binomial)

logit_model2 <- glm(no_congen ~ dem_momage + dem_dadage + mom_bmi + mom_notobaco + 
                      mom_noinfec + med_previs + med_wic + inft_weight + inft_gest,
                    data = sim_data, family = binomial)

# Extract Odds Ratios and Confidence Intervals
odds_ratios1 <- tidy(logit_model1) %>%
  mutate(odds_ratio = exp(estimate),
         lower_ci = exp(estimate - 1.96 * std.error),
         upper_ci = exp(estimate + 1.96 * std.error)) %>%
  filter(term != "(Intercept)")  # Exclude the intercept

odds_ratios2 <- tidy(logit_model2) %>%
  mutate(odds_ratio = exp(estimate),
         lower_ci = exp(estimate - 1.96 * std.error),
         upper_ci = exp(estimate + 1.96 * std.error)) %>%
  filter(term != "(Intercept)")  # Exclude the intercept

#### Odds Ratio Bar Chart ####

# Define custom labels for predictor variables
custom_labels <- c(
  "dem_momage" = "Mom Age",
  "dem_dadage" = "Dad Age",
  "mom_bmi" = "Mom BMI",
  "mom_notobaco" = "No Tobacco",
  "mom_noinfec" = "No Infections",
  "med_previs" = "Prenatal Visits",
  "med_wic" = "WIC",
  "inft_weight" = "Birth Weight",
  "inft_gest" = "Gestation Period"
)

# Create the bar chart
odds_ratio_plot1 <- odds_ratios1 %>%
  ggplot(aes(x = reorder(term, odds_ratio), y = odds_ratio)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "grey", width = 0.6) +
  geom_errorbar(aes(ymin = lower_ci, ymax = upper_ci), width = 0.2, color = "blue") +
  geom_hline(yintercept = 1, linetype = "dashed", color = "blue") +
  coord_flip() +
  labs(title = "Odds Ratio Bar Chart for Abnormal Conditions of Infants",
       x = "Predictor Variables",
       y = "Odds Ratio (95% CI)") +
  scale_x_discrete(labels = custom_labels) +
  theme_minimal() +  # Use minimal theme
  theme(
    panel.background = element_rect(fill = "white"),  # Background color of the plot area
    plot.background = element_rect(fill = "white"),   # Background color of the entire plot
    panel.grid.major = element_line(color = "grey80"), # Major grid lines
    panel.grid.minor = element_line(color = "grey90")  # Minor grid lines
  )

odds_ratio_plot2 <- odds_ratios2 %>%
  ggplot(aes(x = reorder(term, odds_ratio), y = odds_ratio)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "grey", width = 0.6) +
  geom_errorbar(aes(ymin = lower_ci, ymax = upper_ci), width = 0.2, color = "blue") +
  geom_hline(yintercept = 1, linetype = "dashed", color = "blue") +
  coord_flip() +
  labs(title = "Odds Ratio Bar Chart for Congenial Anomalies of Infants",
       x = "Predictor Variables",
       y = "Odds Ratio (95% CI)") +
  scale_x_discrete(labels = custom_labels) +
  theme_minimal() +  # Use minimal theme
  theme(
    panel.background = element_rect(fill = "white"),  # Background color of the plot area
    plot.background = element_rect(fill = "white"),   # Background color of the entire plot
    panel.grid.major = element_line(color = "grey80"), # Major grid lines
    panel.grid.minor = element_line(color = "grey90")  # Minor grid lines
  )

# Save Odds Ratio Bar Chart as PNG
ggsave("data/00-simulated_data/simulated_results/odds_ratio_abnorm.png", odds_ratio_plot1, width = 8, height = 6)
ggsave("data/00-simulated_data/simulated_results/odds_ratio_congen.png", odds_ratio_plot2, width = 8, height = 6)


#### ROC Curve ####
# Predict probabilities for the outcome variable
sim_data$predicted_abnorm <- predict(logit_model1, newdata = sim_data, type = "response")
sim_data$predicted_congen <- predict(logit_model2, newdata = sim_data, type = "response")

# Generate ROC curve and calculate AUC
roc_curve1 <- roc(sim_data$no_abnorm, sim_data$predicted_abnorm)
roc_curve2 <- roc(sim_data$no_congen, sim_data$predicted_congen)

# Create the ROC plot
roc_data1 <- data.frame(tpr = roc_curve1$sensitivities, fpr = 1 - roc_curve1$specificities)
roc_data2 <- data.frame(tpr = roc_curve2$sensitivities, fpr = 1 - roc_curve2$specificities)

roc_plot1 <- ggplot(roc_data1, aes(x = fpr, y = tpr)) +
  geom_line(color = "blue", size = 1) +
  geom_abline(linetype = "dashed", color = "red") +
  labs(title = "ROC Curve for Abnormal Conditions of Infants",
       x = "False Positive Rate",
       y = "True Positive Rate") +
  theme_minimal() +  # Use minimal theme
  theme(
    panel.background = element_rect(fill = "white"),  # Background color of the plot area
    plot.background = element_rect(fill = "white"),   # Background color of the entire plot
    panel.grid.major = element_line(color = "grey80"), # Major grid lines
    panel.grid.minor = element_line(color = "grey90")  # Minor grid lines
  )

roc_plot2 <- ggplot(roc_data2, aes(x = fpr, y = tpr)) +
  geom_line(color = "blue", size = 1) +
  geom_abline(linetype = "dashed", color = "red") +
  labs(title = "ROC Curve for Congenial Anomalies of Infants",
       x = "False Positive Rate",
       y = "True Positive Rate") +
  theme_minimal() +  # Use minimal theme
  theme(
    panel.background = element_rect(fill = "white"),  # Background color of the plot area
    plot.background = element_rect(fill = "white"),   # Background color of the entire plot
    panel.grid.major = element_line(color = "grey80"), # Major grid lines
    panel.grid.minor = element_line(color = "grey90")  # Minor grid lines
  )

# Save ROC Curve as PNG
ggsave("data/00-simulated_data/simulated_results/roc_abnorm.png", roc_plot1, width = 8, height = 6)
ggsave("data/00-simulated_data/simulated_results/roc_congen.png", roc_plot2, width = 8, height = 6)

#### Save AUC Value ####
auc_abnorm <- round(auc(roc_curve1), 2)
auc_congen <- round(auc(roc_curve2), 2)

cat("AUC:", auc_abnorm, "\n")
cat("AUC:", auc_congen, "\n")

# Save AUC value to a text file
writeLines(paste("AUC:", auc_abnorm), "data/00-simulated_data/simulated_results/auc_abnorm.txt")
writeLines(paste("AUC:", auc_congen), "data/00-simulated_data/simulated_results/auc_congen.txt")