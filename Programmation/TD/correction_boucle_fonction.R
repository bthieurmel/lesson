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

#6. compareFact

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
#' compareFact(5)
#' compareFact(5, type = "while")
#' 
compareFact <- function(n, type = "for"){
  
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
compareFact(5)
compareFact(5, type = "while")
compareFact(5, type = "repeat")
compareFact(5, type = "frf")
compareFact(0)
compareFact(-1)
compareFact("a")

#8. microbenchmark
require(microbenchmark)
?microbenchmark

microbenchmark(compareFact(100000, type = "while"), 
               compareFact(100000, type = "repeat"), 
               compareFact(100000, type = "for"))
