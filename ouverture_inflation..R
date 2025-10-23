install.packages(c("WDI","plm","lmtest","sandwich","ggplot2"))
install.packages("ggrepel")

library(ggrepel) 
library(WDI)
library(plm)
library(lmtest)
library(sandwich)
library(ggplot2)

# Pays de l'OCDE
countries <- c("FRA","DEU","ITA","ESP","GBR","USA","JPN","CAN","NLD","SWE","NOR","CHE","AUS","NZL","FIN","DNK","BEL","PRT")

# Téléchargement des indicateurs WDI
data <- WDI(
  country = countries,
  indicator = c(
    "inflation" = "FP.CPI.TOTL.ZG",
    "open_pct" = "NE.TRD.GNFS.ZS",
    "gdp" = "NY.GDP.MKTP.KD"
  ),
  start = 1990,
  end = 2020
)

data <- na.omit(data)
names(data) <- c("iso2","country","year","inflation","open_pct","gdp")

# Panel data
pdata <- pdata.frame(data, index = c("iso2","year"))

# Modèle à effets fixes pays
model_fe <- plm(inflation ~ open_pct + log(gdp), data = pdata, model = "within", effect = "individual")

# Résumé avec erreurs robustes
summary(coeftest(model_fe, vcov = vcovHC(model_fe, type="HC1", cluster="group")))

# Graphique : relation moyenne ouverture / inflation
df_avg <- aggregate(cbind(inflation, open_pct) ~ country, data, mean)
ggplot(df_avg, aes(x = open_pct, y = inflation)) +
  geom_point(color = "darkblue", size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  ggrepel::geom_text_repel(aes(label = country),
                           size = 3, color = "black", max.overlaps = 15) +
  theme_minimal() +
  scale_y_continuous(limits = c(min(df_avg$inflation) - 1, max(df_avg$inflation) + 1)) +
  labs(
    x = "Ouverture commerciale (% du PIB)",
    y = "Inflation moyenne (%)",
    title = "Relation entre ouverture commerciale et inflation (OCDE, 1990–2020)"
  )

# Comparaison effets fixes vs aléatoires (test de Hausman)

# Modèle à effets aléatoires
model_re <- plm(inflation ~ open_pct + log(gdp), data = pdata, model = "random")

# Test de Hausman
hausman_test <- phtest(model_fe, model_re)
print("TEST DE HAUSMAN")
print(hausman_test)

# Interprétation automatique
if (hausman_test$p.value < 0.05) {
  cat("\n📊 Résultat : Effets fixes préférés (p < 0.05) → différences systématiques entre pays.\n")
} else {
  cat("\n📊 Résultat : Effets aléatoires préférés (p >= 0.05) → hypothèse de non-corrélation acceptée.\n")
}

# Résumé du modèle retenu
cat("RÉSUMÉ DU MODÈLE RETENU")
if (hausman_test$p.value < 0.05) {
  print(summary(coeftest(model_fe, vcov = vcovHC(model_fe, type = "HC1", cluster = "group"))))
} else {
  print(summary(coeftest(model_re, vcov = vcovHC(model_re, type = "HC1", cluster = "group"))))
}
