install.packages("readxl")
install.packages("corrplot")
install.packages("fBasics")
install.packages("ggplot2")
install.packages("stargazer")
install.packages("ggeffects")
install.packages("nlme")
install.packages("lmtest")
install.packages("forecast")
install.packages("urca")
install.packages("car")
library(readxl)
library(corrplot)
library(fBasics)
library(ggplot2)
library(stargazer)
library(ggeffects)
library(nlme)
library(lmtest)
library(forecast)
library(urca)
library(car)

getwd()
setwd("/Users/meryem/Desktop")

# ----------- MODÈLE 1 : VARIABLES "LOGIQUES" ---------------

data1 <- read_xlsx("/Users/meryem/Desktop/données 1.xlsx", col_names = TRUE, col_types = 'numeric')

y <- (data1$`PIB par habitant (en dollars constants)`)
x1 <- (data1$`Formation Brute de Capital Fixe, Investissement (en dollars constants de 2015)`)
x2 <- (data1$`Dépenses de consommation finale des ménages (en dollars courant)`)
x3 <- (data1$`Exportations (en dollars courants)`)
x4 <- (data1$`Taux de chômage (% de la population active)`)

data2 <- as.data.frame(data1)
attach(data2)

# Statistiques descriptives
stargazer(data2, title = "Statistiques descriptives", type = "text")

#coeffs de corrélation entre les variables
cor(y, x1, use = "complete.obs") #coeff de -0,49 : relation inverse : augmentent dans le sens inverse, quand l'investissement augmente, le PIB baisse. Cela peut s'expliquer par un changement structurel/effet temporel ("décennie perdue")
cor(y, x2, use = "complete.obs") #coeff de 0,52 : relation positive : quand les dépenses de consommation augmentent, le PIB augmente.
cor(y, x3, use = "complete.obs") #coeff de 0,90 : relation très forte : quand les exportations augmentent, le PIB augmente fortement
cor(y, x4, use = "complete.obs") #coeff de 0,04 : relation très faible : quand le taux de chômage augmente, le PIB augmente très peu, voire pas du tout

# Matrice de corrélation entre les variables
data3 <- data.frame(y, x1, x2, x3, x4)
mcor <- cor(data3, use = "complete.obs")
corrplot(mcor, method = "circle")

# Graphiques récapitulatifs de l'évolution des données :

#PIB
f <- ggplot(data2, aes(Année, y), color = "#be1558")
f +  geom_point(size = 3, color = "#be1558")+
  geom_line(size = 1, color = "#be1558") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "pink")+
  labs(x = "Années",
       y = "PIB en milliards de dollars",
       title = "Évolution du PIB au Japon entre 1990 et 2020")

#Investissement
g <- ggplot(data2, aes(Année, x1), color = "blue")
g +  geom_point(size = 3, color = "blue") +
  geom_line(size = 1, color = "blue") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "#c6d7eb")+
  labs(x = "Années",
       y = "FBCF (Investissements)",
       title = "Évolution des investissements au Japon entre 1990 et 2020")

#Dépenses de consommation
h <- ggplot(data2, aes(Année, x2), color = "#be1558")
h +  geom_point(size = 3, color = "#be1558") +
  geom_line(size = 1, color = "#be1558") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "pink")+
  labs(x = "Années",
       y = "Dépenses de consommation",
       title = "Évolution des dépenses de consommation au Japon de 1990 à 2020")

#Exportations
i <- ggplot(data2, aes(Année, x3), color = "#be1558")
i +  geom_point(size = 3, color = "#be1558") +
  geom_line(size = 1, color = "#be1558") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "pink")+
  labs(x = "Années",
       y = "Exportations",
       title = "Évolution des exportations au Japon de 1990 à 2020")

#Chômage
j <- ggplot(data2, aes(Année, x4), color = "#be1558")
j +  geom_point(size = 3, color = "#be1558") +
  geom_line(size = 1, color = "#be1558") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "pink")+
  labs(x = "Années",
       y = "Taux de chômage (en % de la population active)",
       title = "Évolution du chômage au Japon de 1990 à 2020")

#Créeons des graphiques du PIB par habitant en fonction de chaque variable indépendante séparément

#1 : graphique PIB - Investissements (y ~ x1)
graph1 <- ggplot(data=data2, aes(y=y, x=x1, fill ='Droite estimation'))+ geom_point(size =2)+
  geom_smooth(method ='lm', se = TRUE, fullrange = TRUE, level = 0.99, linetype = 'dashed', fill = 'pink' )+
  ggtitle("Relation entre le PIB et l'investissement au Japon entre 1990 et 2020")+
  scale_x_continuous(name ="Investissement")+
  scale_y_continuous(name ="PIB/habitant")+
  theme_grey()
graph1 + scale_fill_discrete(name='Légende')

#2 : graphique PIB - Dépenses de consommation (y ~ x2)
graph2 <- ggplot(data=data2, aes(y= y, x= x2, fill ='Droite estimation'))+ geom_point(size =2)+
  geom_smooth(method ='lm', se = TRUE, fullrange = TRUE, level = 0.99, linetype = 'dashed', fill = 'pink' )+
  ggtitle("Relation entre le PIB et les dépenses de consommation au Japon entre 1990 et 2020")+
  scale_x_continuous(name ="Dépenses de consommation")+
  scale_y_continuous(name ="PIB/habitant")+
  theme_grey()
graph2 + scale_fill_discrete(name='Légende')

#3 : graphique PIB - Exportations totales
graph3 <- ggplot(data=data2, aes(y= y, x= x3, fill ='Droite estimation'))+ geom_point(size =2)+
  geom_smooth(method ='lm', se = TRUE, fullrange = TRUE, level = 0.99, linetype = 'dashed', fill = 'pink' )+
  ggtitle("Relation entre le PIB et les exportations totales au Japon entre 1990 et 2020")+
  scale_x_continuous(name ="Exportations totales")+
  scale_y_continuous(name ="PIB/habitant")+
  theme_grey()
graph3 + scale_fill_discrete(name='Légende')

#4 : graphique PIB - Taux de chômage
graph4 <- ggplot(data=data2, aes(y= y, x= x4, fill ='Droite estimation'))+ geom_point(size =2)+
  geom_smooth(method ='lm', se = TRUE, fullrange = TRUE, level = 0.99, linetype = 'dashed', fill = 'pink' )+
  ggtitle("Relation entre le PIB et le taux de chômage au Japon entre 1990 et 2020")+
  scale_x_continuous(name ="Taux de chômage")+
  scale_y_continuous(name ="PIB/habitant")+
  theme_grey()
graph4 + scale_fill_discrete(name='Légende')



# ------------- MODÈLE 2 : VARIABLES "MOINS LOGIQUES -------------
data3 <- read_xlsx("/Users/meryem/Desktop/Données 2.xlsx", col_names = TRUE, col_types ='numeric')

View(data3)
summary(data3)

y <- (data3$`PIB par habitant (en dollars constant)`)
z1 <- (data3$`Taux de dépendance des personnes âgées (en % des travailleurs)`)
z2 <- (data3$`Coefficient de Gini (inégalités économiques, compris entre 0 et 1)`)
z3 <- (data3$`Émissions de CO2 (en tonnes métriques/hab)`)
z4 <- (data3$`IDH (indice de développement humain)`)
z5 <- (data3$`Densité de population (en km^2/hab)`)

data4 <- as.data.frame(data3)
attach(data4)

#statistiques descriptives
stargazer(data4, title = "Statistiques descriptives", type = "text")

#coeffs de corrélation entre les variables
cor(y, z1, use = "complete.obs") #coeff de 0,95 : relation très forte : augmentent dans le même sens, quand le taux de dépendance des personnes âgées augmente, le PIB par habitant augmente fortement
cor(y, z2, use = "complete.obs") #coeff de 0,74 : relation forte : plus il y a d'inégalités économiques au Japon, plus le PIB par habitant augmente
cor(y, z3, use = "complete.obs") #coeff de -0,21 : relation inverse faible : quand les émissions de CO2 par habitant augmentent, le PIB par habitant baisse
cor(y, z4, use = "complete.obs") #coeff de 0,95 : relation très forte : quand l'IDH augmente, le PIB par habitant augmente fortement
cor(y, z5, use = "complete.obs") #coeff de 0,64 : relation très forte : quand la densité de population augmente, le PIB par habitant augmente fortement


#matrice de corrélation entre les variables
data5 <- data.frame(y, z1, z2, z3, z4, z5)
mcor <- cor(data5[, ], use = "complete.obs")
corrplot(mcor, method="circle")


#graphiques récapitulatifs de l'évolution des données :

#Taux de dépendance des personnes âgées 
k <- ggplot(data4, aes(Années, z1), color = "blue")
k +  geom_point(size = 3, color = "blue") +
  geom_line(size = 1, color = "blue") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "#c6d7eb")+
  labs(x = "Années",
       y = "Taux de dépendance des personnes âgées ",
       title = "Évolution du taux de dépendance des personnes âgées au Japon entre 1990 et 2020")

#Coefficient de Gini
l <- ggplot(data4, aes(Années, z2), color = "#be1558")
l +  geom_point(size = 3, color = "#be1558") +
  geom_line(size = 1, color = "#be1558") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "pink")+
  labs(x = "Années",
       y = "Coefficient de Gini",
       title = "Évolution du coefficient de Gini au Japon de 1990 à 2020")

#Émissions de CO2
m <- ggplot(data4, aes(Années, z3), color = "#be1558")
m +  geom_point(size = 3, color = "#be1558") +
  geom_line(size = 1, color = "#be1558") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "pink")+
  labs(x = "Années",
       y = "Émissions de CO2 (tonnes par habitant)",
       title = "Évolution des émissions de CO2 par hab au Japon de 1990 à 2020")

#IDH
n <- ggplot(data4, aes(Années, z4), color = "#be1558")
n +  geom_point(size = 3, color = "#be1558") +
  geom_line(size = 1, color = "#be1558") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "pink")+
  labs(x = "Années",
       y = "IDH",
       title = "Évolution de l'IDH au Japon de 1990 à 2020")

#Densité de population
n <- ggplot(data4, aes(Années, z5), color = "#be1558")
n +  geom_point(size = 3, color = "#be1558") +
  geom_line(size = 1, color = "#be1558") +
  geom_smooth(size = 0.5, color = "black", linetype = 'dashed', fill = "pink")+
  labs(x = "Années",
       y = "Densité de population",
       title = "Évolution de la densité de population au Japon de 1990 à 2020")


#Créeons des graphiques du PIB par habitant en fonction de chaque variable indépendante séparément

#1 : graphique PIB - taux de dépendance des personnes âgées (y ~ z1)
graph5 <- ggplot(data=data4, aes(y=y, x=z1, fill ='Droite estimation'))+ geom_point(size =2)+
  geom_smooth(method ='lm', se = TRUE, fullrange = TRUE, level = 0.99, linetype = 'dashed', fill = 'pink' )+
  ggtitle("Relation entre le PIB et le taux de dépendance des seniors au Japon entre 1990 et 2020")+
  scale_x_continuous(name ="Taux de dépendance des seniors")+
  scale_y_continuous(name ="PIB/habitant")+
  theme_grey()
graph5 + scale_fill_discrete(name='Légende')

#2 : graphique PIB - coefficient de Gini (y ~ z2)
graph6 <- ggplot(data=data4, aes(y= y, x= z2, fill ='Droite estimation'))+ geom_point(size =2)+
  geom_smooth(method ='lm', se = TRUE, fullrange = TRUE, level = 0.99, linetype = 'dashed', fill = 'pink' )+
  ggtitle("Relation entre le PIB et le coefficient de Gini au Japon entre 1990 et 2020")+
  scale_x_continuous(name ="Coefficient de Gini")+
  scale_y_continuous(name ="PIB/habitant")+
  theme_grey()
graph6 + scale_fill_discrete(name='Légende')

#3 : graphique PIB - émissions de CO2 par hab (y ~ z3)
graph7 <- ggplot(data=data4, aes(y= y, x= z3, fill ='Droite estimation'))+ geom_point(size =2)+
  geom_smooth(method ='lm', se = TRUE, fullrange = TRUE, level = 0.99, linetype = 'dashed', fill = 'pink' )+
  ggtitle("Relation entre le PIB et les émissions de CO2 au Japon entre 1990 et 2020")+
  scale_x_continuous(name ="Emissions de CO2 par hab")+
  scale_y_continuous(name ="PIB/habitant")+
  theme_grey()
graph7 + scale_fill_discrete(name='Légende')

#4 : graphique PIB - IDH (y ~ z4)
graph8 <- ggplot(data=data4, aes(y= y, x= z4, fill ='Droite estimation'))+ geom_point(size =2)+
  geom_smooth(method ='lm', se = TRUE, fullrange = TRUE, level = 0.99, linetype = 'dashed', fill = 'pink' )+
  ggtitle("Relation entre le PIB et l'IDH au Japon entre 1990 et 2020")+
  scale_x_continuous(name ="IDH")+
  scale_y_continuous(name ="PIB/habitant")+
  theme_grey()
graph8 + scale_fill_discrete(name='Légende')

#4 : graphique PIB - densité de population (y ~ z5)
graph9 <- ggplot(data=data4, aes(y= y, x= z5, fill ='Droite estimation'))+ geom_point(size =2)+
  geom_smooth(method ='lm', se = TRUE, fullrange = TRUE, level = 0.99, linetype = 'dashed', fill = 'pink' )+
  ggtitle("Relation entre le PIB et la densité de population au Japon entre 1990 et 2020")+
  scale_x_continuous(name ="Densité de population")+
  scale_y_continuous(name ="PIB/habitant")+
  theme_grey()
graph9 + scale_fill_discrete(name='Légende')


#--------------------------- RÉGRESSION --------------------------------------

# ------- MODÈLE 1 : VARIABLES "LOGIQUES" -------

# Régression 1
reg1 <- lm(y ~ x1 + x2 + x3 + x4, data = data2)
summary(reg1)

#regardons à présent l'effet des coefficients individuellement 
reg1beta0 <- coef(reg1)["(Intercept)"] #quand toutes les variables explicatives sont constantes, le PIB par habitant est de 16347 dollars.
reg1beta1 <- coef(reg1)["x1"] #une augmentation d'un milliard de dollars de l'investissement augmente le PIB par habitant de 11,3 dollars environ
reg1beta2 <- coef(reg1)["x2"] #une augmentation d'un milliard de dollars des dépenses de consommation des ménages diminue le PIB par habitant de 1,74 dollars. Une augmentation des dépenses de consommation des ménages pourrait réduire le PIB par habitant si elle se traduit par une hausse des importations, un financement par endettement, ou un manque d'investissements productifs
reg1beta3 <- coef(reg1)["x3"] #une augmentation d'un milliard de dollars des exportations de biens et services augmente le PIB par habitant de 17 dollars environ.
reg1beta4 <- coef(reg1)["x4"] #une augmentation du taux de chômage d'un point de pourcentage augmente le PIB par habitant de 511 dollars. Une augmentation du taux de chômage de 1 point de pourcentage augmente le PIB par habitant de 511 dollars, ce qui pourrait s'expliquer par le fait que les gains de productivité peuvent être liés à une restructuration économique ou une automatisation accrue

#illustrons la régression 1 à l'aide d'un tableau
summary(reg1)
#R^2 = 0,91 environ -> explique 91% des variations du PIB/ habitant japonais

#analyse de de la dispersion des erreurs de prédiction par rapport à la moyenne de la variable indépendante y dans le modèle de regréssion 1 
sigma(reg1)/mean(data1$`PIB par habitant (en dollars constants)`)
#il y a 0,2% d'erreur environ

# Tests statistiques pour évaluer la significativité du modèle

shapiro.test(residuals(reg1))  # Test de normalité
#comme p-value >0.05 (= 0.6526), on ne rejette pas l'hypothèse nulle et conclue que les données de population sont normalement dsitribuées
#donc homoscédasticité
bptest(reg1)  # Test d'hétéroscédasticité
#comme p-value = 0,08456, on ne rejette pas l'hypothèse nulle. Il n'y a donc pas d'hétéroscédasticité.

# Durbin-Watson pour tester l'autocorrélation des résidus
dwtest(reg1)
#autocorrélation significative des résidus, avec une p-value < 0.05.

# ------- MODÈLE 2 : VARIABLES "MOINS LOGIQUES" -------

# Régression 2
reg2 <- lm(y ~ z1 + z2 + z3 + log(z4) + z5, data = data4)
summary(reg2)

#regardons à présent l'effet des coefficients individuellement 
reg2beta0 <- coef(reg2)["(Intercept)"] #lorsque le taux de dépendance des personnes agées, le coefficient de Gini, les émissions de CO2, l'IDH et la densité de population sont constants, le PIB/hab est de 180533 dollars par habitant environ
reg2beta1 <- coef(reg2)["z1"] #une augmentation de 1 point de pourcentage du taux de dépendance des personnes âgées entraîne une diminution du PIB de 53,1 dollars environ
reg2beta2 <- coef(reg2)["z2"] #une augmentation de 1 unité du coefficient de Gini augmente le PIB/hab de 11760 dollars environ. Cela peut être interprété comme une concentration de richesse stimulant l'investissement mais au détriment de l'équité sociale
reg2beta3 <- coef(reg2)["z3"] #une augmentation de 1 tonne métrique des émissions de CO₂ par habitant augmente le PIB/hab de 721 dollars environ
reg2beta4 <- coef(reg2)["log(z4)"] #une augmentation de 1 unité de l'IDH est associée à une augmentation du PIB/hab de 160366 dollars environ
reg2beta5 <- coef(reg2)["z5"] #une augmentation de 1 habitant/km² de la densité de population diminue le PIB/hab de 404 dollars environ. Cela peut être s'expliquer par de la surpopulation qui crée des déséquilibres démographiques/économiques

#illustrons la régression 1 à l'aide d'un tableau
stargazer(reg2, title = "Modèle de régression 2", type = "text")
summary(reg2)
#R^2 = 0,96 environ -> explique 96% des variations du PIB par habitant japonais -> explique mieux que le premier modèle

#analyse de de la dispersion des erreurs de prédiction par rapport à la moyenne de la variable indépendante y dans le modèle de regréssion 1 
sigma(reg2)/mean(data1$`PIB par habitant (en dollars constants)`)
#il y a 0,1% d'erreur environ


# Tests statistiques pour le modèle 2
shapiro.test(residuals(reg2))  # Test de normalité
#p-value > 0.05 donc on ne rejette pas l'hypothèse nulle et conclue que les données de population sont normalement dsitribuées
#donc homoscédasticité
bptest(reg2)  # Test d'hétéroscédasticité
#comme p-value = 0.08, on peut rejeter l'hypothèse nulle. Il n'y a donc pas d'hétéroscédasticité


# Durbin-Watson pour tester l'autocorrélation des résidus
dwtest(residuals(reg2) ~ 1)
#autocorrélation significative des résidus comme p-value < 0.05

# Comparaison des modèles 1 et 2 : AIC et BIC
AIC(reg1, reg2)
BIC(reg1, reg2)
#le modèle 2 a un AIC et un BIC plus bas que le modèle 1 donc il est préférable au 1e modèle. 
#Les modèles AR(1) et AR(2) n'ont pas réussi à corriger l'autocorrélation.
#Nous allons donc corriger son autocorrélation forte significative avec le modèle ARIMA comme expliqué précedemment.

# ------- MODÈLE ARIMA AVEC RÉGRESSIONS EXPLICATIVES -------

# Créeons un data frame avec les variables sans valeurs manquantes
data5 <- na.omit(data.frame(y, z1, z2, z3, z4, z5))

# Vérifiez la structure des données nettoyées
str(data5)
summary(data5)

# Créer une matrice explicative pour le modèle ARIMA
xreg_matrix <- as.matrix(data5[, c("z1", "z2", "z3", "z4", "z5")])

# Ajuster un modèle ARIMA avec les variables explicatives comme régresseurs
reg1_arima <- auto.arima(data5$y, xreg = xreg_matrix)
summary(reg1_arima)

#une augmentation de 1 unité du taux de dépendance des personnes âgées entraîne une réduction de 36.16 dollars du PIB par habitant.
#une augmentation de 1 unité du coefficient de Gini est associée à une augmentation de 10 573.92 dollars du PIB par habitant.
#une augmentation de 1 tonne métrique des émissions de CO₂ par habitant entraîne une augmentation de 958.81 dollars du PIB par habitant.
#une augmentation de 1 unité de l'indice de développement humain (IDH) est associée à une augmentation de 172 826.10 dollars du PIB par habitant.
#une augmentation de 1 habitant/km² de la densité de population réduit le PIB par habitant de 386.54 dollars.

# Test de Durbin-Watson sur les résidus du modèle ARIMA
dwtest(residuals(reg1_arima) ~ 1)
# DW = 1,9128 indique que les résidus ont une autocorrélation faible
#Les résidus du modèle ARIMA ne présentent pas d'autocorrélation significative, ce qui suggère que le modèle est bien ajusté.

# Faire des prévisions avec le modèle ARIMA
forecast_arima <- forecast(reg1_arima, xreg = xreg_matrix)
plot(forecast_arima, main = "Prévisions ARIMA avec variables explicatives")

