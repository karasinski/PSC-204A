import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


#Inspiration
#http://www.cpc.unc.edu/projects/nutrans/publications/Penny-obes%20incidence%20AJCN.pdf
cols2 = {'Gender': 'BIO_SEX2',
         'Age': 'CALCAGE2',
         'Weight': 'H2WS16W',
         'Height (ft)': 'H2WS16HF',
         'Height (in)': 'H2WS16HI'}

cols3 = {'Gender': 'BIO_SEX3',
         'Age': 'CALCAGE3',
         'Weight': 'H3WGT',
         'Height (ft)': 'H3HGT_F',
         'Height (in)': 'H3HGT_I'}


def calc_bmi(df, d=2):
    if d == 2:
        cols = cols2
    elif d == 3:
        cols = cols3

    df = df[list(cols.values())].convert_objects(convert_numeric=True)
    df['weight_lbs'] = df[cols['Weight']]
    df['height_in'] = df[cols['Height (in)']]
    df['height_in'] += 12 * df[cols['Height (ft)']]
    df['bmi'] = df.apply(lambda x: (x['weight_lbs']/x['height_in']**2) * 703, axis=1)
    df = df[1 < df.bmi]
    df = df[df.bmi < 100].dropna()

    return df

def load_data():
    df2 = pd.read_csv('../ExtraCredit/Option 2 Research/Data_Wave02.tsv', sep='\t')
    df3 = pd.read_csv('../ExtraCredit/Option 2 Research/Data_Wave03.tsv', sep='\t')

    df2 = calc_bmi(df2)
    df3 = calc_bmi(df3, d=3)
    return df2, df3

def plot(df2, df3):
    sns.set(style="white", color_codes=True)
    f, ax = sns.plt.subplots()
    sns.kdeplot(df2.bmi, ax=ax, shade=True, color='k', gridsize=10000, clip=(15, 45))
    sns.kdeplot(df3.bmi, ax=ax, shade=True, color='k', ls='dashed', gridsize=10000, clip=(15, 45))

    plt.legend(['Wave 2 (1996; ages 13-20 y)', 'Wave 3 (2001; ages 19-26 y)'], fontsize=15)
    plt.xlim(15, 45)

    ax.annotate('10.9%', xy=(25, .02), xytext=(30.5, .005), color='k')
    ax.annotate('22.1%', xy=(25, .04), xytext=(30.5, .02), color='k')

    y1 = ax.lines[0].get_ydata()
    x1 = ax.lines[0].get_xdata()
    x_mask1 = np.ma.masked_less_equal(x1, 30).mask
    y_masked1 = np.ma.masked_array(y1, x_mask1)

    y2 = ax.lines[1].get_ydata()
    x2 = ax.lines[1].get_xdata()
    x_mask2 = np.ma.masked_less_equal(x2, 30).mask
    y_masked2 = np.ma.masked_array(y2, x_mask2)

    ax.fill_between(x2, np.zeros_like(y2), y_masked2, facecolor='red', interpolate=True, alpha=0.5)
    ax.fill_between(x1, np.zeros_like(y1), y_masked1, facecolor='white', interpolate=True)
    ax.fill_between(x2, np.zeros_like(y2), y_masked2, facecolor='red', interpolate=True, alpha=0.25)

    plt.vlines(x=30, ymin=0, ymax=0.0398, color='k', linewidth=2, alpha=1)#, ls='dashed')

    plt.xticks(size=15)
    plt.yticks(size=15)

    plt.ylabel('Frequency', fontsize=15)
    plt.xlabel('BMI (kg/m$^2$)', fontsize=15)
    plt.tight_layout()
    plt.show()
    #plt.savefig('plot.pdf')


if __name__ == "__main__":
    df2, df3 = load_data()
    plot(df2, df3)
