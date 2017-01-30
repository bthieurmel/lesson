
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Premiers pas avec shiny"),
  
  fluidRow(
    column(2, 
           wellPanel(
             numericInput("bins",
                          "Number of bins:",min = 1,
                          max = 50,value = 30),
             selectInput("couleur", "Couleur :",
                         choices = c("red", "blue", "green"), 
                         selected = "blue"),
             selectInput("variable", "Variable :", 
                         choices = colnames(faithful)),
             textInput("titre", "Titre :", value = "Histogramme")
           )
    ),
    column(10, 
           tabsetPanel(
             tabPanel("Plot", plotOutput("distPlot")),
             tabPanel("Data",           
                    # affichage du nombre de classes. On le centre ici avec une div
                    # textOutput("nbbins")
                    div(textOutput("nbbins"), align = "center"),
                    
                    # affichage des donnees
                    dataTableOutput("view_data"),
                    
                    # summary des donnees
                    verbatimTextOutput("summary_data"))
           )
           

    )
  )
))
