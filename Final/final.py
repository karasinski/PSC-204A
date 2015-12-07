import numpy as np
import pandas as pd
from statsmodels.formula.api import ols
from statsmodels.stats.anova import anova_lm
import matplotlib.pyplot as plt
from scipy.stats import ttest_ind
from statsmodels.stats.multicomp import MultiComparison
from scipy.stats.distributions import norm
import seaborn as sns
sns.set_style('ticks')

###############################################################################
# PROBLEM 1 $##################################################################
###############################################################################

df = pd.read_csv('tempmood.csv')
df['day'] = df.index.tolist()
d = pd.melt(df, id_vars=['day', 'temp'], value_vars=['part1', 'part2', 'part3', 'part4'],
            value_name='mood', var_name='id')

#sns.jointplot('temp', 'mood', data=d, xlim=(74, 88), ylim=(0, 12), space=0,
              #kind='reg')
#plt.savefig('p1-mean.pdf')
#plt.close('all')

#sns.lmplot(x='temp', y='mood', hue='id', col='id', col_wrap=2, data=d, size=3)
#plt.savefig('p1-persubj.pdf')
#plt.close('all')

stats = pd.DataFrame.from_dict({'mean':df.mean(), 'std':df.std()})
print(stats)

import statsmodels.api as sm
def fit_line(x, y):
    """Return slope, intercept of best fit line."""
    X = sm.add_constant(x)
    model = sm.OLS(y, X, missing='drop') # ignores entires where x or y is NaN
    fit = model.fit()
    print(fit.f_pvalue)
    return fit.params[1], fit.params[0] # could also return stderr in each via fit.bse
    #return fit

m, b = fit_line(d.temp, d.mood)
print("Slope: {:.2f} Intercept: {:.2f}".format(m, b))

for i in range(1, 5):
    print("Subject: {:d}, Slope: {:.2f} Intercept: {:.2f}"
          .format(i, *fit_line(df.temp, df['part' + str(i)])))

#from scipy.stats import norm
#t = df['temp']
#m1 = df['part1']
#m2 = df['part2']
#m3 = df['part3']
#m4 = df['part4']

#res = []
#for m_1 in [m1, m2, m3, m4]:
#    mcor1  = pd.concat((t, m_1), axis=1).corr().temp[1]
#    mcor1z = 0.5 * np.log((1+mcor1)/(1-mcor1))
#    for m_2 in [m1, m2, m3, m4]:
#        mcor2 = pd.concat((t, m_2), axis=1).corr().temp[1]
#        mcor2z = 0.5 * np.log((1+mcor2)/(1-mcor2))
#        zres = (mcor2z - mcor1z)/np.sqrt(2/(len(m_2)-3))
#        p = 2*norm.sf(zres)
#        #print(p)
#        res.append(p)
#res = pd.DataFrame(np.array(res).reshape(4, 4))
#labels = ['Subject' + str(i) for i in range(1, 5)]
#res.columns, res.index = labels, labels

## Show just the lower triangular
#print(res.mask(np.triu(np.ones(res.shape)).astype(np.bool)))



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
