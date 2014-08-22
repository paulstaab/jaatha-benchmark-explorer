library(shiny)
library(ggplot2)
library(dplyr)

# Two data frames are imported in global.R:
# - data_acc contains relative estimation errors for the parameters
#   of certain models (column model) and jaatha version (column version).
# - data_runtime contains the runtime for jaatha runs (in seconds), again
#   for different models and versions.

shinyServer(function(input, output) { 
  output$plot_acc <- renderPlot({      
    # Check that at least one version and model is selected.
    if (length(input$version) == 0 | length(input$model) == 0)
      stop("Please select at least one version and one model.")
    
    # Set options to either plot accuracy or run time
    if (input$stat == 'Accuracy') {
      data <- data_acc
      detailed_aes <- aes(variable, rel.error, fill=version)
      detailed_y_axis <- scale_y_continuous('Relative Estimation Error')
      detailed_x_axis <- scale_x_discrete('Parameter') 
      overview_y_axis <- 
        scale_y_continuous('Root Mean Squared Relative Estimation Error')
      overview_summarise <- 
        function(x) summarise(x, sumstat = sqrt(mean(rel.error^2)))
    } else {
      data <- data_runtime
      detailed_aes <- aes(model, run.time, fill=version)
      detailed_y_axis <- scale_y_continuous("Runtime (s)")
      detailed_x_axis <- scale_x_discrete('Model')
      overview_y_axis <- scale_y_continuous('Mean Runtime (s)')
      overview_summarise <- 
        function(x) summarise(x, sumstat = mean(run.time))
    }
        
    # Filter selected models and versions
    data <- data %>% 
      filter(version %in% input$version) %>%
      filter(model %in% input$model)
    
    # Plot
    if (length(input$model) == 1) {
      # Provide a detailed view in case only one model is selected.
      # Boxplots are nice for this.
      ggplot(data, detailed_aes) + 
        geom_abline(aes(intercept=0, slope=0)) +
        geom_boxplot(position="dodge") +
        detailed_x_axis +
        detailed_y_axis +
        scale_fill_discrete('Version')
      
    } else {
      
      # Give an overview if we have multiple models by summarizing the 
      # relative errors into a single summary statistic 
      # (root mean squares of the relative errors for accuracy, 
      #  mean for runtime).
      data <- data %>%
        group_by(model, version) %>%
        overview_summarise
      
      ggplot(data, aes(model, sumstat, fill=version)) + 
        geom_bar(stat = "identity", position="dodge") +
        scale_x_discrete('') +
        scale_fill_discrete('Version') +
        overview_y_axis
    }
  })
})