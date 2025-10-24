import numpy as np, pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt, seaborn as sns

np.random.seed(0)
n = 2000
income = np.random.lognormal(mean=7.5, sigma=0.6, size=n)
household_size = np.random.choice([1,2,3,4,5], size=n, p=[0.2,0.35,0.25,0.15,0.05])
education = np.random.choice([0,1,2], size=n, p=[0.4,0.4,0.2])
latent = -3 + 0.0004*income + 0.2*household_size + 0.6*education + np.random.normal(0,1,n)
prob = 1/(1+np.exp(-latent))
choice = (np.random.rand(n) < prob).astype(int)
df = pd.DataFrame({'income':income,'household_size':household_size,'education':education,'choice':choice})

model = smf.logit('choice ~ income + household_size + C(education)', data=df).fit(disp=False)
print(model.summary())

mfx = model.get_margeff()
print(mfx.summary())

df['pred'] = model.predict(df)
sns.regplot(x='income', y='pred', data=df, scatter_kws={'s':5, 'alpha':0.3}, lowess=True)
plt.xlabel('Revenu')
plt.ylabel('Probabilité prédite de consommer')
plt.tight_layout()
plt.savefig('/Users/meryem/Desktop/Meryem-Halheit-Portfolio/Econometrie_Appliquee_Logit/logit_pred_vs_income.png', dpi=150)
print("\n✅ Graphique enregistré sous 'logit_pred_vs_income.png'")
