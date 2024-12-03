#### Preamble ####
# Purpose: Shiny web application for visualizing and analyzing predictions from Random Forest and Bayesian Linear Models for infant health status
# Author: Yunkyung Ko
# Date: 3 December 2024
# Contact: yunkyung.ko@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - The `shiny`, `DT` package must be installed and loaded
# - 05-model_data.R must have been run
# - The user must provide a dataset with numeric features
# Any other information needed? Make sure you are in the `infant_health` rproj


library(shiny)
library(randomForest)  # For prediction
library(readr)         # For reading CSV files
library(DT)            # For interactive data tables
library(ggplot2)       # For visualization

# Load trained models
random_forest_model <- readRDS("models/random_forest.rds")
bayesian_model <- readRDS("models/bayesian_lm.rds")

# Define UI
ui <- fluidPage(
  titlePanel("Infant Health Prediction App"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload Infant Data (CSV)", accept = c(".csv")),
      actionButton("predict", "Run Predictions"),
      hr(),
      h4("Options:"),
      sliderInput("bins", "Number of Bins for Histogram:", min = 5, max = 50, value = 20)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Data Preview", DTOutput("data_table")),
        tabPanel("Prediction Results", DTOutput("predictions_table")),
        tabPanel("Visualizations",
                 plotOutput("rf_hist"),
                 plotOutput("bayesian_hist"))
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Reactive value to store uploaded data
  reactive_data <- reactiveVal(NULL)
  
  # Load and display uploaded dataset
  observeEvent(input$file, {
    req(input$file)
    data <- read_csv(input$file$datapath)
    reactive_data(data)
  })
  
  output$data_table <- renderDT({
    req(reactive_data())
    datatable(reactive_data(), options = list(pageLength = 5), caption = "Uploaded Dataset Preview")
  })
  
  # Run predictions when button is clicked
  predictions <- reactive({
    req(reactive_data())
    data <- reactive_data()
    
    # Ensure all columns are numeric
    if (!all(sapply(data, is.numeric))) {
      stop("All columns in the dataset must be numeric for prediction.")
    }
    
    # Run predictions
    rf_preds <- predict(random_forest_model, newdata = data, type = "raw")
    bayesian_preds <- predict(bayesian_model, newdata = data, type = "response")
    
    # Return as a data frame
    data.frame(Random_Forest = rf_preds, Bayesian_Linear_Model = bayesian_preds)
  })
  
  # Display predictions
  output$predictions_table <- renderDT({
    req(predictions())
    datatable(predictions(), options = list(pageLength = 5), caption = "Prediction Results")
  })
  
  # Visualizations
  output$rf_hist <- renderPlot({
    req(predictions())
    ggplot(predictions(), aes(x = Random_Forest)) +
      geom_histogram(bins = input$bins, fill = "blue", color = "white", alpha = 0.7) +
      labs(title = "Random Forest Predictions", x = "Predicted Classes", y = "Frequency") +
      theme_minimal()
  })
  
  output$bayesian_hist <- renderPlot({
    req(predictions())
    ggplot(predictions(), aes(x = Bayesian_Linear_Model)) +
      geom_histogram(bins = input$bins, fill = "green", color = "white", alpha = 0.7) +
      labs(title = "Bayesian Linear Model Predictions", x = "Predicted Values", y = "Frequency") +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)

