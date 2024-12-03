# The Effects of Labor-Associated Drug Interventions on Neonatal Health Outcomes: A Predictive Analysis of Apgar5 Scores
## Steroids Enhance Neonatal Health, While Antibiotics Show Limited Effectiveness

## Overview

This repo contains the analysis aimed at predicting neonatal health outcomes, specifically the Apgar score, using maternal and delivery-related variables. The project leverages advanced statistical and machine learning techniques, including Bayesian GLM(Generalized Linear Model)s and Random Forests, to address challenges in early neonatal risk assessment. By utilizing datasets from the National Center for Health Statistics, this research aims to support decision making in maternal and neonatal care.


## File Structure

The repo is structured as:

-   `data/00-simulated_data` contains the simulated dataset and the simulated results of this analysis.
-   `data/01-raw_data` was intended to host the original datasets obtained from National Center for Health Statistics (https://data.nber.org/nvss/natality/csv/2023/natality2023us.csv). However, due to memory constraints, large datasets could not be included in this repo. Please refer to the link above to access the original dataset directly.
-   `data/02-analysis_data` contains the cleaned dataset, and the train and test dataste for analyzing the accuracy of the model predictions.
-   `models` contains random forest models and bayesian glm models for predicting the apgar5 score. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, clean, and model data.


## Statement on LLM usage

This project utilized the assistance of ChatGPT 4.0 to enhance the efficiency and accuracy of the data analysis and visualization process. Specifically, it provided guidance in aspects of the codes in R scripts, as well as in creating graphical visualizations. The entire chat history is available in `other/llm_usage/usage.txt`.
