import pandas as pd
from statsmodels.formula.api import ols
from statsmodels.stats.anova import anova_lm
#import matplotlib.pyplot as plt
from scipy.stats import ttest_ind
from statsmodels.stats.multicomp import MultiComparison

df = pd.read_csv('confidence.csv')

# Convert to long format
r = pd.melt(df.reset_index(),
            value_vars=['t1', 't2', 't3'],
            id_vars=['index', 'public'],
            var_name='Time', value_name='Observation')

# Some basic sorting
r = r.sort(['index', 'Time']).reset_index(drop=True)
cols = r.columns.tolist()
cols[0] = 'ID'
r.columns = cols

df = r
df['Time'] = df.Time.apply(lambda x: int(x.split('t')[1]))

# Test for effects between public/private
print(anova_lm(ols("Observation ~ C(public)", df).fit(), typ=2))


from patsy import dmatrix
# This is equivalent to R’s contr.poly
p = dmatrix("C(df.Time, Poly())", df)
poly = pd.DataFrame(p, columns=['Intercept', 'Linear', 'Quadratic'])
df = pd.concat((df, poly), axis=1)
print(anova_lm(ols("Observation ~ C(Time)", data=df).fit()))
#print(MultiComparison(df.Observation, df.Time).allpairtest(ttest_ind, method='b')[0])
print(anova_lm(ols("Observation ~ Linear + Quadratic", data=df).fit(), typ=2))


#print(anova_lm(ols("Observation ~ C(public)*C(Time)", df).fit(), typ=2))

#for value in df.public.unique():
#    print("Public == {}".format(value))
#    mod = MultiComparison(df.query('public == @value').Observation,
#                          df.query('public == @value').Time)
#    res = mod.allpairtest(ttest_ind, method='b')[0]
#    print(res)

#for value in df.Time.unique():
#    print("Time == {}".format(value))
#    mod = MultiComparison(df.query('Time == @value').Observation,
#                          df.query('Time == @value').public)
#    res = mod.allpairtest(ttest_ind, method='b')[0]
#    print(res)


#import numpy as np
#import pandas
#url = 'http://www.ats.ucla.edu/stat/data/hsb2.csv'
#hsb2 = pandas.read_table(url, delimiter=",")
#from patsy.contrasts import Treatment
#levels = [1,2,3,4]
#contrast = Treatment(reference=0).code_without_intercept(levels)
#contrast.matrix[hsb2.race-1, :][:20]
#from statsmodels.formula.api import ols
#mod = ols("write ~ C(race, Treatment)", data=hsb2)
#res = mod.fit()
#print(anova_lm(res))
#from patsy.contrasts import Sum
#contrast = Sum().code_without_intercept(levels)
##print(contrast.matrix)
#mod = ols("write ~ C(race, Sum)", data=hsb2)
#res = mod.fit()
#print(anova_lm(res))
#from patsy.contrasts import Diff
#contrast = Diff().code_without_intercept(levels)
##print(contrast.matrix)
#mod = ols("write ~ C(race, Diff)", data=hsb2)
#res = mod.fit()
#print(anova_lm(res))
#from patsy.contrasts import Helmert
#contrast = Helmert().code_without_intercept(levels)
##print(contrast.matrix)
#mod = ols("write ~ C(race, Helmert)", data=hsb2)
#res = mod.fit()
#print(anova_lm(res))
#_, bins = np.histogram(hsb2.read, 3)
#try: # requires numpy master
#    readcat = np.digitize(hsb2.read, bins, True)
#except:
#    readcat = np.digitize(hsb2.read, bins)
#hsb2['readcat'] = readcat
#from patsy.contrasts import Poly
#levels = hsb2.readcat.unique().tolist()
#contrast = Poly().code_without_intercept(levels)
##print(contrast.matrix)
#mod = ols("write ~ C(readcat, Poly)", data=hsb2)
#res = mod.fit()
#print(anova_lm(res))

import pandas as pd
import seaborn as sns
sns.set_style('ticks')

df = pd.read_csv('glong.csv', index_col=0)
p = sns.lmplot(x='time', y='observation',
               hue='public', #col='public',
               data=df, order=2, ci=95,
               x_jitter=.3, y_jitter=.3,
               legend=False)
p.axes[0][0].set_xticks([1, 2, 3])
p.axes[0][0].set_xticklabels(['Sophomore', 'Junior', 'Senior'])
plt.xlabel('Observation')
plt.ylabel('End-of-Year Student Confidence Rating')
#plt.show()
plt.savefig('prob5-quad.pdf')
plt.close('all')

p = sns.lmplot(x='time', y='observation',
               hue='public', #col='public',
               data=df, order=1, ci=95,
               x_jitter=.3, y_jitter=.3,
               legend=False)
p.axes[0][0].set_xticks([1, 2, 3])
p.axes[0][0].set_xticklabels(['Sophomore', 'Junior', 'Senior'])
plt.xlabel('Observation')
plt.ylabel('End-of-Year Student Confidence Rating')
#plt.show()
plt.savefig('prob5-lin.pdf')
plt.close('all')
