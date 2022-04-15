require(shiny)

onStop(function() rm(".run_explore_data", envir = exploredata.env))

ui <- fluidPage(
  exploredata_ui("id")
)

server <- function(input, output, session) {
  exploredata_server("id",
                     reactive(get(".run_explore_data", envir = exploredata.env)))
}
shinyApp(ui, server)
