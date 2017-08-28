# 1. n! for
n <- 5
res <- 1

for(i in 1:n){
  res <- res * i
}
res

# 2. n! while
n <- 5
res <- 1

while(n > 0){
  res <- res * n
  n <- n - 1
}
res

# 3. n! repeat
n <- 5
res <- 1

repeat{
  res <- res * n
  n <- n - 1
  if(n == 0){
    break
  }
}

res

#4. factFor, ...
factFor <- function(n){
  res <- 1
  
  for(i in 1:n){
    res <- res * i
  }
  
  res
}

factWhile <- function(n){
  res <- 1
  
  while(n > 0){
    res <- res * n
    n <- n - 1
  }
  
  res
}

factRepeat <- function(n){
  res <- 1
  
  repeat{
    res <- res * n
    n <- n - 1
    if(n == 0){
      break
    }
  }
  
  res
}

#5. test
identical(factFor(n = 5), factWhile(n = 5))
identical(factFor(n = 5), factRepeat(n = 5))

#6. factAll

#' Factorielle, avec différentes boucles
#'
#' Cette fonction permet le calcul factorielle, et cela
#' en choisissant la boucle à utiliser
#'
#' @param n : Integer. Entier
#' @param type : Character. Type de boucle. 'for' (défaut), 'while', ou 'repeat'
#' 
#' @return : n!
#' 
#' @examples
#' factAll(5)
#' factAll(5, type = "while")
#' 
factAll <- function(n, type = "for"){
  
  # n est bien un entier ?
  if(!isTRUE(all.equal(n, as.integer(n)))){
    stop("n n'est pas un entier")
  }
  
  # n >= 0
  if(n < 0){
    stop("n doit être >= à 0")
  }
  
  # controle du type
  type <- try(match.arg(type, c("for", "while", "repeat")), silent = TRUE)
  if(class(type) == "try-error"){
    stop("type doit être 'for', 'while', ou 'repeat'")
  }else{
    # message("La boucle utilisée est : ", type)
  }
  
  # cas n == 0
  if(n == 0){
    return(1)
  }
  
  # sinon
  res <- switch(type,
    "for" = factFor(n),
    "while" = factWhile(n),
    "repeat" = factRepeat(n)
  )
  
  res
}

#7. tests
factAll(5)
factAll(5, type = "while")
factAll(5, type = "repeat")
factAll(5, type = "frf")
factAll(0)
factAll(-1)
factAll("a")

#8. microbenchmark
require(microbenchmark)
?microbenchmark

microbenchmark(factAll(100000, type = "while"), 
               factAll(100000, type = "repeat"), 
               factAll(100000, type = "for"))
