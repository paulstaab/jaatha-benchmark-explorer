
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(
  pageWithSidebar(
    headerPanel('Jaatha Benchmark Explorer'),
    sidebarPanel(
      radioButtons('stat', "", choices=list('Accuracy', 'Runtime')),
      
      checkboxGroupInput(inputId='version', label='Versions', inline=TRUE, 
                         choices=levels(data_acc$version),
                         selected=last(levels(data_acc$version))),
         
      checkboxGroupInput(inputId='model', label='Models', inline=TRUE, 
                         choices=levels(data_acc$model),
                         selected=levels(data_acc$model)),
         
      tags$small(paste('Select only one model to get more detailed',
                        'information.')), 
      width = 3
    ),
                        
    mainPanel(
      plotOutput("plot_acc", height='600px'),
      plotOutput("plot_rt", height='600px'), 
      width=9
    )
  )
)