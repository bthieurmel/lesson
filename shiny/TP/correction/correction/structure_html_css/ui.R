
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(
  
  navbarPage(
    header = tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.css")
    ),
    title = "Premiers pas avec shiny",
             # rajout d'un css externe

             tabPanel("Data",
                      # titre avec css
                      div(h1("Jeu de données faithful", style = "color: blue;"), align = "center"),
                      
                      # affichage des donnees
                      dataTableOutput("view_data"),
                      
                      # summary des donnees
                      verbatimTextOutput("summary_data")
             ),
             tabPanel("Visualisation",
                      
                      # Sidebar with a slider input for number of bins
                      fluidRow(
                        column(width = 4,
                               wellPanel(
                                 numericInput("bins",
                                              "Number of bins:",
                                              min = 1,
                                              max = 50,
                                              value = 30),
                                 
                                 # couleur avec un selectInput pour proposer des choix
                                 selectInput("couleur", "Couleur :",
                                             choices = c("red", "blue", "green"), selected = "blue"),
                                 
                                 # choix de la colonne a representer
                                 selectInput("variable", "Variable :", choices = colnames(faithful)),
                                 
                                 # textInput pour rajouter un titre
                                 textInput("titre", "Titre :", value = "Histogramme"), 
                                 
                                 # export des graphiques
                                 downloadLink('downloadGraphiques', 'Exporter les graphiques')
                                 
                               )
                        ),
                        column(width = 8,
                               tabsetPanel(
                                 tabPanel("Histogramme",
                                          plotOutput("distPlot"),
                                          
                                          # affichage du nombre de classes. On le centre ici avec une div
                                          # textOutput("nbbins")
                                          div(textOutput("nbbins"), align = "center")
                                 ),
                                 tabPanel("Boxplot",
                                          plotOutput("distPlot2")
                                 )
                                 
                                 
                               )
                        )
                      )
             ),
             # onglet sur la societe
             tabPanel("About",
                      # rajout d'une image avec img()
                      # elle doit etre dans www
                      img(src = "DATASTORM-GENES.jpg", width = 200),
                      "En tant que filiale du GENES, ", 
                      a(href = "www.datastorm.fr", "DATASTORM"), 
                      " valorise l’ensemble des 
                      activités de recherche du Groupe auprès des entreprises et administrations."
             )
  ))
