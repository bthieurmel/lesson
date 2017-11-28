#-----
# 1
#-----

## Variable Qualitatives
ybrut <- c("g1","g1","g2","g2","g2","g3")
print(ybrut)
summary(ybrut)

y <- factor(ybrut)
levels(y)
nlevels(y)
table(y)
sum(table(y))
table(y)/sum(table(y))*100

barplot(table(y))

barplot(table(y) / sum(table(y)) * 100, ylab = "pourcentages",
        xlab = "groupes", main = "Répartition de y")

summary(y)

#-----
# 2
#-----

## Variable Quantitative continue
source("TD/ressources/varquant.R")
summary(y)

hist(y, freq = TRUE)
hist(y, freq = FALSE)

hist(y, freq = FALSE, breaks = 10, xlab = "huile", main = "Histogramme")

hist(y, freq = FALSE, breaks = c(15,18,25,30,36))

boxplot(y, xlab = "", ylab = "teneur en huile")
mean(y)
abline(h = mean(y))
quantile(y)
median(y)
abline(h = median(y), col = 2)

lnormal <- rnorm(100)
ndens <- density(lnormal, width=1.2)
hist(lnormal, probability = T)
lines(ndens)

#-----
# 3
#-----
## Variable quantitative discrète
y <- c(5,0,2,2,0)

unique(y)
sort(unique(y))
table(y)

plot(sort(unique(y)), table(y), type="h", ylim = c(0, max(table(y))))

barplot(table(y))

#-----
# 4
#-----
tpropre <- read.csv2("TD/ressources/tournesol_propre.csv")

donnees_types <- sapply(tpropre, class)
print(donnees_types)

summary(tpropre)
tpropre$ecotype <- factor(tpropre$ecotype)
tpropre$semflo <- as.numeric(tpropre$semflo)
tpropre$longfeu <- as.numeric(tpropre$longfeu)

#-----
# 5
#-----

plot(huile~grlon, data = tpropre)
plot(huile~grlon, data = tpropre, pch = "+")
plot(huile~grlon, data = tpropre, col = 2, pch = "+")

plot(huile~grlon, data = tpropre, type = "l")

ordre <- order(tpropre$grlon)
plot(x = tpropre$grlon[ordre], y = tpropre$huile[ordre], type = "l",
     lty = 2, lwd = 2, col = "purple")


#-----
# 6
#-----
table(tpropre[,"ecotype"], tpropre[,"etat"])

#-----
# 7
#-----

mean(tpropre$huile)
mean(tpropre$grlon)
mean(tpropre$longfeu)

colMeans(tpropre[, c("huile", "grlon", "longfeu")])
sapply(tpropre[, c("huile", "grlon", "longfeu")], mean)

quantile(tpropre$huile)
quantile(tpropre$grlon)
quantile(tpropre$longfeu)

boxplot(tpropre$huile)
boxplot(tpropre$grlon)
boxplot(tpropre$longfeu)

sapply(tpropre[, c("huile", "grlon", "longfeu")], var)

boxplot(tpropre$huile)
abline(h = mean(tpropre$huile))
abline(h = mean(tpropre$huile) - sqrt(var(tpropre$huile)), col = 2)
abline(h = mean(tpropre$huile) + sqrt(var(tpropre$huile)), col = 2)
boxplot(tpropre$grlon)
abline(h = mean(tpropre$grlon))
abline(h = mean(tpropre$grlon) - sqrt(var(tpropre$grlon)), col = 2)
abline(h = mean(tpropre$grlon) + sqrt(var(tpropre$grlon)), col = 2)
boxplot(tpropre$longfeu)
abline(h = mean(tpropre$longfeu))
abline(h = mean(tpropre$longfeu) - sqrt(var(tpropre$longfeu)), col = 2)
abline(h = mean(tpropre$longfeu) + sqrt(var(tpropre$longfeu)), col = 2)

png(file = "myplot.png")
boxplot(tpropre$huile)
abline(h = mean(tpropre$huile))
abline(h = mean(tpropre$huile) - sqrt(var(tpropre$huile)), col = 2)
abline(h = mean(tpropre$huile) + sqrt(var(tpropre$huile)), col = 2)
dev.off()

