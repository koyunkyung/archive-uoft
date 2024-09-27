# Disease Outbreaks in Toronto Healthcare Institutions: Analysis of Outbreak Patterns Based on Its Type and Settings

## Overview

This repo contains an analysis of outbreaks that occurred in Toronto healthcare institutions from 2020 to the first half of 2024. It mainly focuses on figuring out the trend of fluctuations for each causative agents of outbreaks, which includes COVID-19, Parainfluenza, and so on. By analyzing this in relation to changes in social policies or atmospheres related to the healthcare sector, we would like to further discuss how to prevent more outbreaks from occurring.


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

Aspects of the code in R scripts were written with the help of ChatGPT. The entire chat history is available in other/llm/usage.txt.

