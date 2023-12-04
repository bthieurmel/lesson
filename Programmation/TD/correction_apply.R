data <- read.table("C:/Users/BenoîtThieurmel/Documents/git/lesson/Programmation/TD/flights14.csv", sep = ",", header = TRUE)

# 1. type des colonnes
columns_type <- sapply(X = data, FUN = class)
columns_type

# 2. moyenne des colonnes integer
apply(X = data[, which(columns_type == "integer")], 
      MARGIN = 2, FUN = mean)

# 3. moyenne des colonnes integer, avec données manquantes
data$arr_time[1:10] <- NA
apply(X = data[, columns_type == "integer"], 
      MARGIN = 2, FUN = mean, na.rm = TRUE)

#4. min,max apply
apply(X = data[, columns_type == "integer"], MARGIN = 2, FUN = function(col, na.rm){
  c(min(col, na.rm = na.rm), max(col, na.rm = na.rm))
}, na.rm = FALSE)

#5. min,max  sapply
sapply(X = data[, columns_type == "integer"], FUN = function(col){
  c(min(col, na.rm = TRUE), max(col, na.rm = TRUE))
})

#5. min,max... vapply
vapply(X = data[, columns_type == "integer"], FUN = function(col){
  c(min(col, na.rm = TRUE), max(col, na.rm = TRUE))
}, FUN.VALUE = c(Min. = 0, Max. = 0))

#6. nouvelle colonne itinerary
data$itinerary <- paste(data$origin, data$dest, sep = "-")

#7. CV du temps de vol par itinéraire

# aggregate
system.time({
cv_1 <- aggregate(data$air_time, by = list(data$itinerary), 
          FUN = function(x){sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)})
})

cv_1[which.max(cv_1$x),]

# avec tapply
system.time({
  cv_2 <- tapply(X = data$air_time, INDEX = data$itinerary, 
                 FUN = function(x){sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)})
})
cv_2[which.max(cv_2)]

# split
system.time({
  data_itinerary <- split(data, data$itinerary)
  cv_3 <- sapply(X = data_itinerary, FUN = function(x){sd(x[, "air_time"], na.rm = TRUE) / mean(x[, "air_time"], na.rm = TRUE)})
})
cv_3[which.max(cv_3)]

#8. Performance

system.time(v1 <- mean(data$distance / data$air_time))

system.time(v2 <- mean(mapply(FUN = "/", data$distance, data$air_time)))

ratio3 <- c()
system.time({
  for(i in 1:nrow(data)){
    ratio3 <- c(ratio3, data[i, "distance"] / data[i, "air_time"])
  }
  v3 <- mean(ratio3)
})

