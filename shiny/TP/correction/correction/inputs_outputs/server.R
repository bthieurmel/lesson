
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, input$variable]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = input$couleur, border = 'white',
         main  = input$titre)

  })
  
  # output pour afficher le nombre de classes
  output$nbbins <- renderText({
    paste0("Cet histogramme a été réalisé en utilisant ", 
           input$bins, " classes.")
  })
  
  # output pour afficher les données
  output$view_data <- renderDataTable({
    faithful
  })
  
  # output pour afficher le summary des données
  output$summary_data <- renderPrint({
    summary(faithful)
  })
  
})
