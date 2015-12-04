import pandas as pd
from statsmodels.formula.api import ols
from statsmodels.stats.anova import anova_lm
import matplotlib.pyplot as plt
from scipy.stats import ttest_ind
from statsmodels.stats.multicomp import MultiComparison
import seaborn as sns
sns.set_style('ticks')

###############################################################################
# PROBLEM 1 $##################################################################
###############################################################################

df = pd.read_csv('tempmood.csv')
df['day'] = df.index.tolist()
d = pd.melt(df, id_vars=['day', 'temp'], value_vars=['part1', 'part2', 'part3', 'part4'],
            value_name='mood', var_name='id')

sns.jointplot('temp', 'mood', data=d, xlim=(74, 88), ylim=(0, 12), space=0,
              kind='reg')
df['mean_mood'] = df[df.columns[1:]].mean(axis=1)
sns.jointplot('temp', 'mean_mood', data=df[['temp', 'mean_mood']],
              xlim=(74, 88), ylim=(2, 7), space=0, kind='reg')
plt.savefig('p1-mean.pdf')
plt.close('all')

sns.lmplot(x='temp', y='mood', hue='id', col='id', col_wrap=2, data=d, size=3)
plt.savefig('p1-persubj.pdf')
plt.close('all')

#stats = pd.DataFrame.from_dict({'mean':df.mean(), 'std':df.std()})
#print(stats)

import statsmodels.api as sm
def fit_line(x, y):
    """Return slope, intercept of best fit line."""
    X = sm.add_constant(x)
    model = sm.OLS(y, X, missing='drop') # ignores entires where x or y is NaN
    fit = model.fit()
    return fit.params[1], fit.params[0] # could also return stderr in each via fit.bse
    #return fit

for i in range(1, 5):
   print("Subject: {:d}, Slope: {:.2f} Intercept: {:.2f}"
         .format(i, *fit_line(df.temp, df['part' + str(i)])))

###############################################################################
# PROBLEM 2 $##################################################################
###############################################################################

###############################################################################
# PROBLEM 3 $##################################################################
###############################################################################

#df = pd.read_csv('socialacceptance.csv')
#print(anova_lm(ols('psa ~ C(female)*C(sports)', df).fit(), typ=2))
#print(anova_lm(ols('psa ~ C(female)', df.query('sports == 0')).fit(), typ=2))
#print(anova_lm(ols('psa ~ C(female)', df.query('sports == 1')).fit(), typ=2))
#print(df.query('sports == 1').groupby('female').agg(['mean', 'std']).psa)
#sns.factorplot(x='female', y='psa', hue='sports', data=df, order=[0, 1])
#plt.savefig('p3.pdf')
#plt.close('all')

###############################################################################
# PROBLEM 4 $##################################################################
###############################################################################

###############################################################################
# PROBLEM 5 $##################################################################
###############################################################################

###############################################################################
# PROBLEM 6 $##################################################################
###############################################################################

###############################################################################
# PROBLEM 7 $##################################################################
###############################################################################
