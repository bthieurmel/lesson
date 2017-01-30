
shinyServer(function(input, output, session) { # session pour observe / update
  
  output$distPlot <- renderAmCharts({
    input$goButton
    isolate({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, input$variable]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      amHist(x, control_hist = list(breaks = bins), col = input$couleur,
             main  = input$titre, zoom = TRUE, export = TRUE) 
    })
  })
  
  # output pour afficher le nombre de classes
  output$nbbins <- renderText({
    paste0("Cet histogramme a été réalisé en utilisant ", input$bins, " classes.")
  })
  
  # output pour afficher les données
  output$view_data <- renderDataTable({
    faithful
  })
  
  # output pour afficher le summary des données
  output$summary_data <- renderPrint({
    summary(faithful)
  })
  
  # rajout du boxplot
  output$distPlot2 <- renderAmCharts({
    input$goButton
    x    <- faithful[, isolate(input$variable)]
    # avec la même couleur que l'histogramme
    amBoxplot(x, col = isolate(input$couleur), export = TRUE)
  })
  
  # export des graphiques
  output$downloadGraphiques <- downloadHandler(
    filename = function() {
      paste('graphiques-', Sys.Date(), '.pdf', sep='')
    },
    content = function(con) {
      pdf(file = con)
      
      # histogramme
      x    <- faithful[, input$variable]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      hist(x, breaks = bins, col = input$couleur, border = 'white',
           main  = input$titre)
      
      # boxlpot
      boxplot(x, col = input$couleur)
      
      dev.off()
    }
  )
  
  # observe pour afficher toujours l'histogramme en premier a la validation
  observe({
    input$goButton
    updateTabsetPanel(session, inputId = "graph_panel", selected = "Histogramme")
  })
})
