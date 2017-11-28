#############
######## 1
#############
grillex <- seq(0, 2*pi, length.out = 500)
fx <- sin(grillex)
plot(x = grillex, y = fx, type = "l")
title("Graphe de la fonction sinus")

#############
######## 2
#############
grillex1 <- seq(-3, 3, length.out = 500)
fx1 <- 1/sqrt(2*pi)*exp(-0.5*grillex1*grillex1)

grillex2 <- seq(1, 7, length.out = 500)
fx2 <- 1/sqrt(2*pi)*exp(-0.5*(grillex2 - 4)^2)

par(mfrow=c(2, 1))
plot(x = grillex1, y = fx1)
plot(x = grillex2, y = fx2)

mean(fx1)
sd(fx1)
var(fx1)

mean(fx2)
sd(fx2)
var(fx2)

#############
######## 3
#############
par(mfrow = c(1, 1))
grillex <- seq(-4, 4, length.out = 500)
normDensity <- dnorm(x = grillex, mean = 0, sd = 1)

plot(x = grillex, y = normDensity, type = "l")
student5 <- function (x) {
  dt(x, df = 5)
}
student30 <- function (x) {
  dt(x, df = 30)
}

?curve
curve(student5, from = -4, to = 4, n = 500, add = TRUE, col = 2)
curve(student30, from = -4, to = 4, n = 500, add = TRUE, col = 3)
legend("topleft",legend=c("Normal","Student 5", "Student 30"),col=1:3,lty=1)

#############
######## 4
#############
ozone <- read.csv("ozone.txt", sep="")
summary(ozone)
View(ozone)

plot(x = ozone$T12, y = ozone$maxO3, type = "p")
plot(x = ozone$T12, y = ozone$maxO3, type = "b")

# Order the dataset according to T12
ozoneOrdered <- ozone[order(ozone$T12), ]
plot(x = ozoneOrdered$T12, y = ozoneOrdered$maxO3, type = "b")

pointMax <- ozoneOrdered[ozoneOrdered$maxO3 == max(ozoneOrdered$maxO3), ]
which.max(ozoneOrdered$maxO3)
pointMax

p <- identify(x = ozoneOrdered$T12, y = ozoneOrdered$maxO3, pos = TRUE, n = 5)

#############
######## 5
#############

taches_solaires <- read.csv("taches_solaires.csv", sep=";", dec = ",")
summary(taches_solaires)
View(taches_solaires)


taches_solaires$trentenaire <- as.factor(floor((taches_solaires$annee - 1749) / 30) + 1)

couleurs <- c("yellow", "magenta","orange", "cyan", "grey", "red", "green", "blue")
all(couleurs %in% colors())

palette(couleurs)
plot(taches_solaires$nbe_tach, 
     type = "p", 
     col=taches_solaires$trentenaire, 
     pch = "+",
     xlab="Temps",
     ylab="Nombre de taches")

# Create an index so as to plot properly the timeseries
taches_solaires$index <- seq_along(taches_solaires$nbe_tach)

# Make the link between colors embedded within couleurs and the corresponding integers/factors
palette(couleurs)
plot(x = taches_solaires$index, 
     y = taches_solaires$nbe_tach, 
     type = "p", 
     col=taches_solaires$trentenaire, 
     pch = "+",
     xlab="Temps",
     ylab="Nombre de taches")

# Then add lines : indeed, we are not able to draw points and lines at the same time if we use several different colors
for (couleur in levels(taches_solaires$trentenaire)) {
  selectTemp <- taches_solaires$trentenaire == couleur
  lines(taches_solaires$index[selectTemp], taches_solaires$nbe_tach[selectTemp],col=couleur)
}


#############
######## 6
#############

ozone <- read.csv("ozone.txt", sep="")
summary(ozone)
View(ozone)

plot(x = ozone$T12, 
     y = ozone$T15,
     xlab="T12",
     ylab="T15")

# First draw fat circles
plot(x = ozone$T12, 
     y = ozone$T15,
     col = "purple",
     cex = 5,
     pch = 16,
     xlab = "T12",
     ylab = "T15")
# Then crosses
points(x = ozone$T12,
       y = ozone$T15,
       pch=3)

# Remove Y axis, set large font
plot(x = ozone$T12,
     y = ozone$T15,
     pch = 16,
     yaxt = "n",
     xaxt = "n",
     xlab = "T12",
     ylab = "T15")
# Add Y axis, with numbers in the right direction with las. 
axis(2,las=1, cex.axis=2)
axis(1, cex.axis=2)

#############
######## 7
#############

grillex <- seq(-3.5, 3.5, length = 1000)
normDensity <- dnorm(x = grillex, mean = 0, sd = 1) 

plot(x = grillex, 
     y = normDensity, 
     type = "l",
     xlab = "x",
     ylab = "Densité")

abline(h=0)

# Retrive x for which probability is 95%
confidence95Bound <- qnorm(0.95)
# Construct a boolean vector indicating if X is above confidence95Bound
outside <- grillex >= confidence95Bound

# The polygon fonction takes the contour as argument. Contours are (x, Y) points. 
polygonXContour <- c(grillex[outside], rev(grillex[outside]))
nbXPoints <- length(grillex[outside])
polygonYContour <- c(rep(0, nbXPoints), rev(normDensity[outside]))
polygon(polygonXContour,polygonYContour,col="blue")

arrows(2.7, 0.2, 2, dnorm(2), len=0.1)
text(2.7, 0.2, expression(paste(alpha,"=5%")), pos=3)

#############
######## 8
#############

layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(1:10,10:1,pch=0)
plot(rep(1,4),type="l")
plot(c(2,3,-1,0),type="b")

par(mar=c(2.3,2,0.5,0))
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(1:10,10:1,pch=0)
plot(rep(1,4),type="l")
plot(c(2,3,-1,0),type="b")

par(mar=c(2.3,2,0.5,0))
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE), width=c(4,1),height = c(2,2))
plot(1:10,10:1,pch=0)
plot(rep(1,4),type="l")
plot(c(2,3,-1,0),type="b")

