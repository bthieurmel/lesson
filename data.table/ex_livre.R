set.seed(1234)
dt <- data.table(group1 = c("A", "B"),
group2 = rep(c("C", "D"), each = 5000),
value = rnorm(10000),
weight = sample(1:10, 10000, replace = TRUE))
dt
dt[, 1]
dt[group1 == "A", mean(value), by = group2]
dt[, c(1, 3)] ## marche maintenant !
dt[, value] ## vecteur
dt[, list(value)] ## data.table
dt[, "value"] ## data.table
# plusieurs colonnes
dt[, list(group1, value)] ## data.table
dt[, .(group1, value)] ## raccourci (. == list)
dt[, c("group1", "value")] ## avec des "noms"
## renommage
dt[, list(mygroup = group1, myvalue = value)][1:2]
# creation d'une nouvelle colonne
dt[, tvalue := trunc(value)]
# création de plusieurs colonnes
dt[, c("tvalue", "rvalue") := list(trunc(value), round(value ,2))][1:2] # par référence
dt[, ':=' (tvalue = trunc(value), rvalues = round(value ,2))] # syntaxe alternative
# modification d'une colonne existance
dt[, tvalue := tvalue + 10]
# suppression
dt[, rvalue := NULL]
dt[ group1 %in% "A", weight := weight * 10L][1:2]
dt[, rep(sum(value), 10)]
# sur un sous-ensemble de ligne uniquement : dt <- dt[group == "A", tvalue := tvalue + 100]
dt[, sum(value)] # un vecteur
dt[, list(sum(value))] # un data.table
dt[, list(somme = sum(value), moyenne = mean(value))] # calculs multiples + renommage
dt[group1 == "B" & group2 == "C", list(sum(value), mean(value))]
dt[, list(somme = sum(value)), by = list(pop = group1, poids = weight > 5)]
dt[, mean_group1 := mean(value), by = list(group1)][1:3]
dt[weight > 5, .N, by = list(group1, group2)][order(-N)]
dt[, lapply(.SD, mean), by =  group1, .SDcols = c("value", "weight")]

new_col <- c("t_value", "t_weight")
dt[, c(new_col) := lapply(.SD, trunc), .SDcols = c("value","weight")]


df <- data.frame(x = 1, y = 1)
df2 <- df # nouvelle affectation
df2$y <- 2 # modification de y
df

df2

dt <- data.table(x = 1, y = 1)
dt2 <- dt # nouvelle affectation
dt2[, y := 2] # modification de y
dt
dt2
