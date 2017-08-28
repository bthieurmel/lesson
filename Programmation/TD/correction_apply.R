data <- read.table("C:/Users/Benoit/Desktop/Cours_Agro/Programmation/TD/flights14.csv", sep = ",", header = TRUE)

# 1. type des colonnes
columns_type <- sapply(X = data, FUN = class)
columns_type

# 2. moyenne des colonnes integer
apply(X = data[, which(columns_type == "integer")], MARGIN = 2, 
      FUN = mean)

# 3. moyenne des colonnes integer, avec données manquantes
data$arr_time[1:10] <- NA
apply(X = data[, columns_type == "integer"], MARGIN = 2, FUN = mean, na.rm = TRUE)

#4. min, med, ... apply
apply(X = data[, columns_type == "integer"], MARGIN = 2, FUN = function(col, na.rm){
  c(min(col, na.rm = na.rm), median(col, na.rm = na.rm), mean(col, na.rm = na.rm), max(col, na.rm = na.rm))
}, na.rm = FALSE)

#5. min, med, ... sapply
sapply(X = data[, columns_type == "integer"], FUN = function(col){
  c(min(col, na.rm = TRUE), median(col, na.rm = TRUE), mean(col, na.rm = TRUE), max(col, na.rm = TRUE))
})

#6. min, med, ... vapply
vapply(X = data[, columns_type == "integer"], FUN = function(col){
  c(min(col, na.rm = TRUE), median(col, na.rm = TRUE), mean(col, na.rm = TRUE), max(col, na.rm = TRUE))
}, FUN.VALUE = c(Min. = 0, Median = 0, Mean = 0, Max. = 0))

#7. nouvelle colonne itinerary
data$itinerary <- paste(data$origin, data$dest, sep = "-")

#8. CV du temps de vol par itinéraire


system.time({
  data_itinerary <- split(data, data$itinerary)
  cv <- sapply(X = data_itinerary, FUN = function(x){sd(x[, "air_time"], na.rm = TRUE) / mean(x[, "air_time"], na.rm = TRUE)})
})
cv[which.max(cv)]

# avec tapply
system.time({
  cv2 <- tapply(X = data$air_time, INDEX = data$itinerary, 
       FUN = function(x){sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)})
})
cv2[which.max(cv2)]

#9. Performance

system.time(ratio1 <-data$distance / data$air_time)

system.time(ratio2 <- mapply(FUN = "/", data$distance, data$air_time))

ratio3 <- rep(0, nrow(data))
system.time({
  for(i in 1:nrow(data)){
    ratio3[i] <-  data[i, "distance"] / data[i, "air_time"]
  }
})

