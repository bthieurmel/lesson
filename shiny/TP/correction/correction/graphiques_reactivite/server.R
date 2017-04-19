
shinyServer(function(input, output, session) { # session pour observe / update
  
  # donnees pour les graphiques
  current_data <- reactive({
    faithful[, input$variable]
  })
  
  output$distPlot <- renderAmCharts({
    input$goButton
    isolate({
      # generate bins based on input$bins from ui.R
      bins <- seq(min(current_data()), max(current_data()), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      amHist(current_data(), control_hist = list(breaks = bins), col = input$couleur,
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

    # avec la même couleur que l'histogramme
    amBoxplot(isolate(current_data()), col = isolate(input$couleur), export = TRUE)
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
