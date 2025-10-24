# Croissance du PIB au Japon (1990–2020) – Analyse économétrique et temporelle

## Objectif
Analyser les déterminants du **PIB par habitant au Japon** entre 1990 et 2020  
en combinant des modèles linéaires, des tests statistiques et un ajustement ARIMA.

## Méthodologie
- Données issues de sources officielles (Banque mondiale, OCDE)
- Deux ensembles de variables :
  1. **Variables économiques classiques** : investissement, consommation, exportations, chômage  
  2. **Variables structurelles** : vieillissement, inégalités, CO₂, IDH, densité de population
- Régressions linéaires multiples (`lm`)
- Tests de normalité, hétéroscédasticité et autocorrélation des résidus
- Ajustement d’un **modèle ARIMA avec variables explicatives** pour corriger l’autocorrélation

## Outils et packages
`R`, `ggplot2`, `lmtest`, `forecast`, `urca`, `corrplot`, `stargazer`

## Résultats principaux
- Le modèle économique explique environ 91% de la variance du PIB (R² = 0.91).  
- Le modèle structurel atteint un **R² ≈ 0.96**, montrant une meilleure capacité explicative.  
- Les tests de Durbin-Watson confirment l’autocorrélation des résidus corrigée par le modèle ARIMA.  
- Les variables les plus influentes sur la croissance japonaise :
  - Taux de dépendance des seniors (effet négatif)
  - IDH et exportations (effet positif)
  - Émissions de CO₂ et inégalités (effet mixte)

## Modélisation finale
- **Modèle linéaire :**
  \[
  PIB_i = \beta_0 + \beta_1 \text{Investissement} + \beta_2 \text{Consommation} + \beta_3 \text{Exportations} + \beta_4 \text{Chômage} + \epsilon_i
  \]
- **Modèle ARIMA avec régresseurs :**
  \[
  PIB_t = \phi_1 PIB_{t-1} + \beta_1 z_1 + \beta_2 z_2 + \beta_3 z_3 + \beta_4 z_4 + \beta_5 z_5 + \epsilon_t
  \]
