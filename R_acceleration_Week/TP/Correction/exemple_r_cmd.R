# recuperation des argumnets
args <- commandArgs(trailingOnly = TRUE)

# controle et retour custom
if(length(args) < 3){
  stop("Veuillez renseigner 3 arguments")
  # .Last <- function(){
  #   cat("Veuillez renseigner 3 arguments\n")
  # }
  # quit(status = 5, runLast = TRUE)
}
input_char <- args[1]
input_numeric <- as.numeric(args[2])
input_vector <- eval(parse(text = args[3]))


stopifnot(!is.na(input_numeric))
stopifnot(is.vector(input_vector))

print(input_char) ; print(input_numeric) ; print(input_vector)