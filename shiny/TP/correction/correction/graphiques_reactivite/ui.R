
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
             
             # ligne horizontale
             hr(),
             
             # summary T/F
             checkboxInput("view_summary", "Summary", FALSE),
             
             conditionalPanel(condition = "input.view_summary",
                              # equivalent to "input.view_summary === true"
                              # summary des donnees
                              verbatimTextOutput("summary_data")
             )
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
                        downloadLink('downloadGraphiques', 'Exporter les graphiques'),
                        
                        # action Button
                        actionButton("goButton", "Valider les paramètres")
                        
                      )
               ),
               column(width = 8,
                      tabsetPanel(
                        id = "graph_panel", # for observe
                        tabPanel("Histogramme",
                                 amChartsOutput("distPlot"),
                                 
                                 # affichage du nombre de classes. On le centre ici avec une div
                                 # textOutput("nbbins")
                                 div(textOutput("nbbins"), align = "center")
                        ),
                        tabPanel("Boxplot",
                                 amChartsOutput("distPlot2")
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
