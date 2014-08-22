library(shiny)

shinyUI(
  pageWithSidebar(
    headerPanel('Jaatha Benchmark Explorer'),
    sidebarPanel(
      radioButtons('stat', "", choices=list('Accuracy', 'Runtime')),
      
      checkboxGroupInput(inputId='version', label='Versions', inline=TRUE, 
                         choices=levels(data_acc$version),
                         selected=levels(data_acc$version)),
         
      checkboxGroupInput(inputId='model', label='Models', inline=TRUE, 
                         choices=levels(data_acc$model),
                         selected=levels(data_acc$model)[1:4]),
      
      tags$small(paste('Select only one model to get more detailed',
                        'information.')),
      
      h4("Info"),
      p(a('Jaatha', 
          href='http://cran.r-project.org/web/packages/jaatha/index.html'),
        'is a parameter estimation method for',
        'Evolutionary Biology, available via CRAN package',
        em('jaatha.'), 
        'Given a model of evolution, it estimates',
        'a set of model paramters from genetic data.'),
      p('This shiny app displays results from benchmarks',
        "that are executed for each release ('Versions'). ",
        'In the benchmark',
        'Jaatha is used on simulated data for five different models',
        "('Models', details about them are not important here)",
        'and the relative estimation error and runtime are',
        'calulated.'),
      p('Above, you can select if you want to plot the estimation errors',
        '(accuary) or the runtime for the different models and versions.'),
      p(a('Source Code', 
          href='https://github.com/paulstaab/jaatha-benchmark-explorer'),
        ' - ',
        a('Benchmark Script', 
          href='https://github.com/paulstaab/jaatha-benchmark'),
        ' - ',
        a('Raw Data', 
          href='https://github.com/paulstaab/jaatha-benchmark/blob/master/data_processed/acc_and_runtime.Rda?raw=true')),
      
      width = 3
    ),
                        
    mainPanel(
      plotOutput("plot_acc", height='600px'),
      plotOutput("plot_rt", height='600px'),
      width=9
    )
  )
)