# Économétrie financière – Modélisation de la volatilité et Value-at-Risk
import yfinance as yf
import pandas as pd
import numpy as np
from arch import arch_model
import matplotlib.pyplot as plt
import scipy.stats as st

# Téléchargement des données (S&P500)
data = yf.download('^GSPC', start='2018-01-01', end='2024-10-01', auto_adjust=False)
data['returns'] = 100 * data['Close'].pct_change().dropna()

# Supprimer les valeurs manquantes
returns = data['returns'].dropna()

# Estimation du modèle GARCH(1,1)
model = arch_model(returns, vol='GARCH', p=1, q=1, mean='Constant', dist='normal')
res = model.fit(disp='off')

print(res.summary())

# Graphique : volatilité conditionnelle
plt.figure(figsize=(10,4))
plt.plot(res.conditional_volatility, color='darkblue')
plt.title('Volatilité conditionnelle estimée (GARCH(1,1))')
plt.xlabel('Date')
plt.ylabel('Volatilité (%)')
plt.tight_layout()
plt.savefig('/Users/meryem/Desktop/Meryem-Halheit-Portfolio/Econometrie_Financiere_GARCH/garch_vol.png', dpi=150)
print("✅ Graphique 'garch_vol.png' enregistré.")

# Calcul de la Value-at-Risk (VaR) à 1 %
alpha = 0.01
z = st.norm.ppf(alpha)
sigma_t = res.conditional_volatility
mu = returns.mean()
VaR_param = -(mu + z * sigma_t)

# Graphique : rendements + VaR
plt.figure(figsize=(10,4))
plt.plot(returns.index, returns, label='Rendements')
plt.plot(sigma_t.index, -VaR_param, label='VaR (1%)', color='red')
plt.legend()
plt.title('Value-at-Risk paramétrique (1%)')
plt.xlabel('Date')
plt.ylabel('Rendements (%)')
plt.tight_layout()
plt.savefig('/Users/meryem/Desktop/Meryem-Halheit-Portfolio/Econometrie_Financiere_GARCH/var_plot.png', dpi=150)
print("✅ Graphique 'var_plot.png' enregistré.")
