# cd /home/benoit/bash_example
# Rscript --vanilla td_r_automatisation.R /home/benoit/bash_example/conf.yml
# nohup Rscript --vanilla td_r_automatisation.R /home/benoit/bash_example/conf.yml &

#- initialisation du fichier de log
# init logger

packrat::on()
# packrat::on("/home/benoit/bash_example")

require(futile.logger)

flog.appender(appender.file("log.txt"), name="td.io")
# set layout
layout <- layout.format('[~t] [~l] ~m')
flog.layout(layout, name="td.io")
# and threshold
flog.threshold("INFO", name = "td.io")

withCallingHandlers({
  if(!require(yaml)){
    stop("ce script nécessite la package 'yaml'")
  }
  
  if(!require(data.table)){
    stop("ce script nécessite la package 'data.table'")
  }
  
  # recuperation des argumnets
  args <- commandArgs(trailingOnly = TRUE)
  
  #- 1 : path d'un yaml contenant
  #- path_report : path du rapport
  #- path_file : path d'un fichier .csv à importer
  #- n_rows : nombre de lignes à afficher
  
  if(length(args) < 1){
    stop("path du fichier de configuration manquant")
  }
  
  # lecture de la configuration
  conf <- try(yaml::yaml.load_file(args[1]), silent = TRUE)
  if("try-error" %in% class(conf)){
    stop("Erreur lors de la lecture du fichier de configuration : ", conf[1])
  }
  
  # controle du fichier de configuration
  if(any(!c("path_report", "path_file", "n_rows") %in% names(conf))){
    stop("Le fichier de configuration doit contenir les champs 'path_report', 'path_file', et 'n_rows'")
  }
  
  stopifnot(is.numeric(conf$n_rows))
  stopifnot(conf$n_rows > 0)
  
  # importation du fichier
  data <- try(fread(conf$path_file), silent = TRUE)
  if("try-error" %in% class(data)){
    stop("Erreur lors de l'importation du fichier : ", data[1])
  }
  
  # affichade de n lignes
  sink(conf$path_report)
  
  cat("Données \n")
  cat(format(Sys.time(), "%a, %d %b %Y %H:%M:%S"), "\n\n")
  print(head(data, n = conf$n_rows))
  cat("\n\n")
  # fermeture de la redirection
  sink()
  
}, simpleError  = function(e){
  futile.logger::flog.fatal(gsub("^(Error in withCallingHandlers[[:punct:]]{3}[[:space:]]*)|(\n)*$", "", e), name="td.io")
}, warning = function(w){
  futile.logger::flog.warn(gsub("(\n)*$", "", w$message), name = "td.io")
}, message = function(m){
  futile.logger::flog.info(gsub("(\n)*$", "", m$message), name = "td.io") 
})