import pandas as pd
from statsmodels.formula.api import ols
from statsmodels.stats.anova import anova_lm
import matplotlib.pyplot as plt

df = pd.read_csv('hw06data.csv')

#1. Descriptive statistics
#A. Sample Size

#How many volunteers were assigned to each lifting condition overall?
print(df.groupby('workout').apply(len))
#How many female volunteers were assigned to each lifting condition?
#How many male volunteers were assigned to each lifting condition?
print(df.groupby(('biosex', 'workout')).apply(len))

#B. Percent Gain Descriptives by Conditions

#What are the mean and standard deviation of percent gain overall,
#for each condition, and for all condition interactions?
overall = (pd.DataFrame({'mean': df.mean(), 'std': df.std()}))
overall.index = ['overall']
biosex = (df.groupby('biosex').pctgain.agg(['mean', 'std']))
workout = (df.groupby('workout').pctgain.agg(['mean', 'std']))
single_factors = pd.concat((overall, biosex, workout))
print(single_factors)
print(df.groupby(('biosex', 'workout')).agg(['mean', 'std']))

#3.
#a. Conduct a factorial ANOVA testing the main effect of biological sex, lifting condition, and their interaction.
print(anova_lm(ols("pctgain ~ C(biosex)*C(workout)", df).fit(), typ=2))

#b. What conclusions do you reach? Explain these in terms of the study. Make sure you incorporate reporting of your statistical analyses into your conclusion.



#plt.figure(figsize=(8,6))
#fig = interaction_plot(df['workout'], df['biosex'], df['pctgain'],
#                       colors=['red', 'blue'], markers=['D','^'],
#                       ms=10, ax=plt.gca())
#plt.show()

