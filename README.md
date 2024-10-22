# Kamala Harris Rises as the 2024 Election Front Runner: A Poll-of-Polls Forecast
## How Poll Aggregation Reveals US Presidental Race Trends

## Overview

This repo contains an analysis of polling trends for Kamala Harris in the 2024 US presidential election, aiming to forecast possible electoral outcomes. Using the polling data from FiveThirtyEight, the analysis applies both linear regression and Bayesian modeling taking into account methodological peculiarities of polling such as pollsters and geographical scope. Our objective is to correct for variation across different voter bases with the pooling the polls approach and narrow down the estimates for the 2024 US presidential election outcomes.


## File Structure

The repo is structured as:

-   `data/00-simulated_data` contains simulated data and test plots corresponding to each analysis conducted in this paper.
-   `data/01-raw_data` contains the raw data as obtained from https://projects.fivethirtyeight.com/polls/data/president_polls.csv.
-   `data/02-analysis_data` contains the cleaned and filtered dataset that was constructed.
-   `models` contains linear and Bayesian models that forecasts the support for Harris taking into account pollster-specific effects and state-level random effects.
-   `other` contains details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, test, download, and clean the data. R scripts for exploratory data analysis and model design are also included.


## Statement on LLM usage

This project utilized the assistance of ChatGPT 4.0 to enhance the efficiency and accuracy of the data analysis and visualization process. Specifically, it provided guidance in aspects of the codes in R scripts, as well as in generating insights through creation of graphical visualizations. The entire chat history is available in `other/llm/usage.txt`.


