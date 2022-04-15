#' @export
#' @rdname exploredata_module
exploredata_ui <- function(id, label = "Variable :") {
  ns <- shiny::NS(id)
  shiny::tagList(
    # choix de la variable à afficher
    shiny::selectInput(ns("variable"), choices = NULL, label = label),
    # affichage du graphique
    shiny::plotOutput(ns("explore_uni"))
  )
}
#' Shiny module for explore data
#'
#' @param id : module id
#' @param data : \code{data.frame} to explore
#' @param label : \code{character} name of column input
#'
#' @return \code{NULL}
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' data("exploredata_ex")
#'
#' ui <- fluidPage(
#'   exploredata_ui("id")
#' )
#'
#' server <- function(input, output, session) {
#'   exploredata_server("id",
#'     reactive(exploredata_ex)
#'   )
#' }
#'
#' shinyApp(ui, server)
#'
#' }
#'
#' @import shiny
#' @rdname exploredata_module
exploredata_server <- function(id, data) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      # updare des colonnes dispo
      shiny::observe({
        shiny::req(data())
        shiny::updateSelectInput(session, "variable", choices = colnames(data()))
      })

      # graphique
      output$explore_uni <- shiny::renderPlot({
        data <- data()
        shiny::req(data)
        shiny::req(input$variable)
        explore_uni(data[[input$variable]])
      })
    }
  )
}


#' Run explore data shiny app
#'
#' @param data : a \code{data.frame}
#'
#' @return NULL
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' run_explore_data_app(iris)
#'
#' }
#'
#' @import shiny
run_explore_data_app <- function(data){
  assign(".run_explore_data", data, envir = exploredata.env)
  shiny::runApp(system.file("explore_app/", package = "exploredata"))
}
