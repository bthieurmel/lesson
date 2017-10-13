library(data.table)

# 1. importation
flights <- fread("C:/Users/Benoit/Desktop/Cours_Agro/Programmation/TD/flights14.csv") 
flights 
dim(flights)
tables()

# pour comparer les temps de calculs
df <- data.frame(flights)

# 2. Selectionner les 10 premieres lignes.
flights[1:10]
flights[1:10, ]
flights[1:10, ,]

# 3. Selectionner les lignes qui ont pour origin l’aeroport JFK et aﬀecter le resultat dans jfk.
flights[origin == "JFK"]



system.time(
  test.dt <- flights[origin == "JFK"]
)

system.time(
  test.df1 <- df[df$origin == "JFK", ]
)

system.time(
  test.df2 <- subset(df, origin == "JFK")
)

# 4. Selectionner les lignes qui ont pour origin l’aeroport JFK et comme date de vol le mois (month) de juillet.
flights[origin == "JFK" & month == 7]

system.time(
  test.dt <- flights[origin == "JFK" & month == 7]
)

system.time(
  test.df <- df[df$origin == "JFK" & df$month == 7, ]
)


# 5 Ordonner jfk par mois, jour, dep_time.
ff <- flights[order(month, day, dep_time)] 

system.time(
  res <- flights[order(month, day, dep_time)]
)

system.time(
  res <- df[order(df$month, df$day, df$dep_time), ]
)

# ou avec la fonction setorder 
setorder(flights, month, day, dep_time)

# ou en mettant des cles..
setkey(flights, month, day, dep_time)

tables() # pour voir les cles
setkey(flights, NULL) # si on veut les supprimer


# 6. Ordonner jfk par mois, jour, dep_time (ordre decroissant)
# tout decroissant
flights[order(month, day, dep_time, decreasing = TRUE)]

# seulement une colonne
flights[order(month, day, -dep_time)]

setorder(flights, month, day, -dep_time)

# pas possible avec des cles en decroissant


# 7. Selectionner la premiere colonne de flights et renvoyer un vecteur (tester le resultat avec is.vector).
is.vector(flights[, year])

# 8. Selectionner la premiere colonne de flights et renvoyer un data.table (tester le resultat avec is.data.table).
is.data.table(flights[, .(year)])
is.data.table(flights[, list(year)])

# 9. Aﬃcher le nuage de points air_time fonction de distance.
system.time(
  flights[, plot(air_time, distance)]
)

system.time(
  plot(flights[, air_time], flights[, distance])
)

# 10. Aﬃcher le nuage de points air_time fonction de distance avec une couleur qui depend du mois, 
# puis du carrier (convertir ce dernier en factor puis en as.numeric)

flights[, plot(air_time, distance, col = month)]
flights[, plot(air_time, distance, col = as.numeric(as.factor(carrier)))]

# 11. Aﬃcher le nuage de points air_time fonction de distance par mois (sur une fenetre graphique contenant 10 graphiques)
par(mfrow=c(2,5))
flights[, plot(air_time~distance, main = paste0("Mois : ", month)), by = .(month)]

# 12. Eﬀectuer une regression lineaire simple air_time fonction de distance.
mod <- flights[, lm(air_time ~ distance)]
mod

# et par mois ?
mod_month <- flights[, list(model = list(lm(air_time ~ distance))), by = month]
mod_month

mod_month[1, model[[1]]]

# 13. Calculer le nombre de vols qui demarrent de JFK par mois
flights[origin == "JFK", .N, by = .(month)]

# renommage
flights[origin == "JFK", list(nrows = .N), by = month]

# on peut affecter le résultat d'agrégation à toutes les lignes
flights[, n_v := .N, by = list(month, origin)]
flights


# avec une cle
setkey(flights, origin)
flights["JFK", .N, by = .(month)]

# 14. Calculer le nombre de vols qui demarrent de JFK par mois,jour
flights[origin == "JFK", .(nbvols = .N), by = .(month, day)]

flights[origin == "JFK", .(nbvols = .N), 
by = c("month", "day")]
# avec une cle
setkey(flights, origin)
flights["JFK", .(nbvols = .N), by = .(month, day)]

# 15. Calculer le nombre moyen de vol par jour, sur tous les mois, grâce à un chainage
flights[origin=="JFK", .N,by=.(month, day)][, mean(N), by = month]

# 16. Calculer le nombre de vols qui demarrent de JFK et qui arrive (dest) a LAX.
flights[origin=="JFK" & dest == "LAX", .N]

# avec une cle
setkey(flights, origin, dest)
tables()
flights[list("JFK", "LAX"), .N]

# 17. Faire la moyenne des retards au depart (dep_delay) et a l’arrivee (arr_delay) par compagnie (carrier)
flights[, .(dep = mean(dep_delay), arr = mean(arr_delay)), by = carrier]

# pire compagnie ?
flights[, list(dep = mean(dep_delay), arr = mean(arr_delay)), by = carrier][order(-dep)]

# 18. Utiliser l’operateur de .SD pour faire les quantiles des retards au depart (dep_delay) et a l’arrivee (arr_delay) par compagnie (carrier) via .SDcols
flights[,  lapply(.SD, quantile), 
        by = carrier, .SDcols = c("dep_delay","arr_delay")]

# ou
inter = flights[, .(dep_delay,arr_delay,carrier)]
inter[,lapply(.SD, quantile), by = carrier]


# 19. Creer un data.table ﬀ qui est la concatenation en colonne de ﬂights et la distance au carre contenue dans ﬂights (cbind)

system.time(ff1 <- cbind(flights, d2 <- flights$distance^2))

# 20. Refaire la meme chose en utilisant l’operateur :=
system.time(ff2 <- flights[, d2 := distance^2])

# 21. Rajouter un "F" devant les valeurs de la colonne flight
flights[, flight := paste0("F", flight)]

# 22. Créer une colonne speed égale à  distance /(air_time/60)
flights[, speed := distance / (air_time/60)]

# 23. Créer deux nouvelles colonnes : trip, concaténation de origin et dest, et delay, somme de arr_delay et dep_delay
flights[, c("trip", "delay") := list(paste(origin, dest, sep = "-"), arr_delay + dep_delay)]


# 24. Que fait cette ligne de code ?
flights[, max_speed := max(speed), by=.(trip)]

# 25. Remplacer, pour la colonne origin, le code JFK par JFKennedy
flights[origin == "JFK", origin := "JFKennedy"]

# 26. Creons le data.table miniature suivant :
DT <- data.table(ID = c("b","b","b","a","a","c"), x = 1:6, y = 7:12, z = 13:18)

# 27. que font :
DT[, .(val = c(x, y)), by = ID]
DT[, .(val = c(x, y)), by = ID][1,val]

DT[, .(val = list(c(x, y))), by = ID]
DT[, .(val = list(c(x, y))), by = ID][1,val]

DT[, .(val = list(paste(x, y, sep = ":"))), by=ID] 
DT[, .(val = list(paste(x, y, sep = ":"))), by=ID][1, val]

DT[, .(val = list(paste(x, y, sep = ":")))]
DT[, .(val = list(paste(x, y, sep = ":")))][1, val]



