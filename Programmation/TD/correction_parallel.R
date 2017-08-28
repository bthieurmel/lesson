data <- read.table("C:/Users/Benoit/Desktop/Cours_Agro/Programmation/TD/flights14.csv", sep = ",", header = TRUE)

#1. jeu de données par mois
data_month <- split(data, data$month)

#2 et 3 - modèle
require(randomForest)

# apply
system.time({
  res <- lapply(X = data_month, FUN = function(don){
    randomForest(dep_delay ~ day + dep_time + hour + min, don, ntree = 30)
  })
})

# parallel

require(parallel)
system.time({
  
  # ouverture du cluster
  cl <- makeCluster(2)

  # chargement du package dans les coeurs
  clusterEvalQ(cl, expr = {
    require(randomForest)
  })
  
  res2 <- parLapply(cl, X = data_month, fun = function(don){
    randomForest(dep_delay ~ day + dep_time + hour + min, don, ntree = 30)
  })
  
  stopCluster(cl)
})

# foreach

require(foreach)
require(doParallel)

system.time({
  
  # ouverture du cluster
  cl <- makeCluster(2)
  
  # avec foreach, il faut enregistrer le cluster
  registerDoParallel(cl)
  
  res3 <- foreach(don = data_month, .packages = "randomForest") %dopar% {
    randomForest(dep_delay ~ day + dep_time + hour + min, don, ntree = 30)
  }

  stopCluster(cl)
})


# 4. Evolution du nombre de coeurs

max.cores <- detectCores()

time <- sapply(1:max.cores, function(core){
  system.time({
    cl <- makeCluster(core)
    # avec foreach, il faut enregistrer le cluster
    registerDoParallel(cl)
    
    res <- foreach(don = data_month, .packages = "randomForest") %dopar% {
      randomForest(dep_delay ~ day + dep_time + hour + min, don, ntree = 30)
    }
    
    stopCluster(cl)
  })[["elapsed"]]
})


res.time <- c(60.81,31.28,25.66,22.91,21.91,21.69,26.18,28.74)
plot(1:8, res.time, type = "l", xlab = "cores", ylab = "time")
