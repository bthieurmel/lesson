#############
######## 2
#############

#-----
# 2.1
#-----

2+2
# blabla
2+2 # ceci est une addition
pi
exp(2)
log(10)
sin(5*pi)
(1+3/5)*5

#-----
# 2.2
#-----

mean(c(4, 10, 16))

# 1. Calculer la moyenne de 1, 3, 5, 4, et 8.

mean(c(1, 3, 5, 4, 8))

# 2. Calculer la somme (sum) de 4, 10 et 16

sum(c(4, 10, 16))

# 3. Calculer la m´ediane (median) de 4, 10 et 16

median(c(4, 10, 16))

#-----
# 2.3
#-----
x <- pi
print(x)
x
1
objects()
y = pi
objects()
y
x<- c(4, 10, 16)
print(x)
x

# 1. Calculer le max (max) de x.
max(x)

# 2. Calculer le min (min) de x.
min(x)

# 3. Calculer la moyenne (mean) de x.
mean(x)

# 4. Calculer la longueur (length) de x.
length(x)

# 5. Calculer le résumé (summary) de x.
summary(x)

#############
######## 3
#############

#-----
# 3.1
#-----

y <- c(-1, 5, 0)
x
y
x+ y
-y

x + 2
abs(y)

x * y
x / y
x^2

1:3
1:10
-1:5
-(1:5)

#-----
# 3.2
#-----

w <- c(TRUE, FALSE, FALSE)
sum(w)
any(w) # au-moins une valeur TRUE
all(w) # toutes les valeurs TRUE
!w # négation
# opérateurs logiques
(TRUE) & (FALSE)
(TRUE) | (FALSE)
(TRUE) | (TRUE)

#-----
# 3.3
#-----

log(0)
log(Inf)
1/0
0/0
max(c( 0/0, 1, 10))
max(c(NA, 1, 10))
max(c(NA, 1, 10), na.rm = T)
max(c(-Inf, 1, 10))
is.finite(c(-Inf, 1, 10))
is.na(c(NA, 1, 10))
is.nan(c(NaN, 1, 10))

#-----
# 3.4
#-----

# 1. Créer le vecteur d’entier de 5 a 23.
5:23

# 2. Créer le vecteur de 6 `a 24 allant de 2 en 2.
seq(6, 24, by = 2)

# 3. Créer le vecteur de 100 valeurs r´eguli`erement espac´ees entre 0 et 1.
seq(0, 1, length.out = 100)

# 4. Créer le vecteur suivant
# [1] 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5
rep(1:5, 4)
# 5. Créer le vecteur suivant
# > [1] 1 1 1 2 2 2 3 3 3 4 4 4 5 5 5
rep(1:5, each = 3)
# 6. Créer le vecteur suivant
# [1] 1 1 2 2 2 3 3 3 3
rep(1:3, each = 2)

#-----
# 3.5
#-----

x[1]
x[2]
x[c(1, 2, 3)]
x[1:3]
x[c(2, 2, 1, 3)]
x[c(1:3, 2, 1)]
x[-1]
x[-c(1, 2)]
x[-(1:2)]

objects()
vec1 <- c(3, NA, 4)
objects()
vec2 <- c(FALSE, TRUE, FALSE)
objects(pattern = "vec*")
vec2
vec1
vec1[vec2]
is.na(vec1)

vec1 <- runif(20)
vec1[vec1>0.5] <- NA

vec1[is.na(vec1)] <- 0

#############
######## 4
#############

#-----
# 4
#-----

don1 <- read.table("TD/ressources/tab1.csv", sep = ",")
don1

don2 <- read.table("TD/ressources/tab2.csv", sep = ";", header = TRUE, dec = ",")
don2

don3 <- read.table("TD/ressources/tab3.csv", sep = ";", header = TRUE, dec = ",")
don3

summary(don3)

#-----
# 4.1
#-----

rownames(don3) ## c'est un vecteur
names(don3) ## c'est un vecteur
colnames(don3) ## c'est un vecteur
colnames(don1)[2]
colnames(don1)[2] <- "var2"
colnames(don1)
colnames(don1) <- colnames(don2)
colnames(don1) <- c("variable1","variable2")

#-----
# 4.2
#-----

don1[1,]
don3[,"sexe"]
don3$sexe
don3[,2]
don3[,c(FALSE, TRUE)]
don3[,c("taille", "sexe")]
don1[1,2]
don1[,1:2]
don1[-1,]
don1[c(2, 3),c(2, 1)]
don1[c( TRUE, FALSE, TRUE), ]
don1[don1[,1]>0, ]
don1[-(1), ]
don1[,c(2, 1)]

#-----
# 4.3
#-----

don1[,1] + don1[,2]
exp(don1[, 1])
don1[1,] + don1[2,]

#-----
# 4.4
#-----

don1 <- read.table("TD/ressources/test1.csv", sep = ";", dec = ",", header = T)
don2 <- read.table("TD/ressources/test2.csv", sep = ";", dec = ",", header = T)
don3 <- read.table("TD/ressources/test3.csv", sep = ";", dec = ",", header = T)

don4 <- cbind(don2, don3)
don4
don5 = rbind(don1, don2)
don5
rbind(don1, don3)
objects()
rm(don4, don5)
objects()

#-----
# merge
#-----

tpropre <- read.csv2("TD/ressources/tournesol.csv")
meteo <- read.csv2("TD/ressources/meteo_tournesol.csv")
merge_res <- merge(tpropre, meteo, by = "ecotype", all.x = TRUE)

saveRDS(merge_res, file = "tournesol.RDS")
tournesol <- readRDS(file = "tournesol.RDS")

#-----
# 5
#-----

data(mtcars)

summary(mtcars)

conso <- cut(mtcars$mpg, breaks = seq(from = 10, to = max(mtcars$mpg) + 5, by = 5))

levels(conso)

conso2 <- conso

levels(conso2) <- c("fuse", "fuse", "(20,25]", "(25,30]", "(30,35]")

ordered(conso)

table(conso)

table(conso)/length(conso)*100

tconso <- table(conso)
tconso/sum(tconso)*100

summary(conso)

colMeans(mtcars, na.rm = TRUE)

colSums(mtcars[, 1:4], na.rm = TRUE)

#-----
# 6
#-----
str <- c("Logiciel", "R")
str[1]
nchar(str)
tolower(str)
toupper(str)
paste(str, collapse = "-")
paste(str[1], str[2], sep = "-")
paste("Jour", 1:3)
paste("Jour", 1:3, sep = "")
c(paste0("Jour", 1:3), paste("Heure", 1:4, sep = "."), str)

gsub("Logiciel", "Software", str)
grep("Logiciel", str)
grep("Logiciel", str, value = TRUE)
grepl("Logiciel", str)


v_mail <- c("robert.dupont@gmail.com", "12345@.fr", "contact@hotmail.fr", 
            "blabla", "12345@", "rdupont@@gmail.com")

regmatches(v_mail, regexpr("^[[:alnum:]._-]+@[[:alnum:].-]+((.com)|(.fr)){1}$", v_mail)) 

