# How Toronto Should Manage the Crisis in the Air: Analysis of Disease Outbreak Patterns Based on Its Type and Settings

## Overview

This repo contains an analysis of disease outbreak trends in Toronto healthcare institutions from year 2016 to 2024. It mainly focuses on figuring out how the frequency trends of outbreak differ by its type and occurrence settings. By analyzing this in relation to changes in social policies or atmospheres related to the healthcare sector, we would like to further discuss how to deal with oncoming outbreaks.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from https://open.toronto.ca/dataset/outbreaks-in-toronto-healthcare-institutions/.
-   `data/raw_data/simulated_data` contains simulation data corresponding to each analysis conducted in this paper.
-   `data/raw_data/simulated_results` contains test results of simulation data, regarding its sanity and hypothesis verification.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `other` contains details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

This project utilized the assistance of ChatGPT 4.0 to enhance the efficiency and accuracy of the data analysis and visualization process. Specifically, it provided guidance in aspects of the codes in R scripts, as well as in generating insights through creation of graphical visualizations. The entire chat history is available in other/llm/usage.txt.

