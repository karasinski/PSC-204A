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
    sns.kdeplot(df2.bmi, ax=ax, shade=True)
    sns.kdeplot(df3.bmi, ax=ax, shade=True)
    plt.legend(['Wave 2', 'Wave 3'])
    plt.xlim(10, 60)
    #plt.axvline(18.5, color='k', linewidth=1)#, ls='dashed')
    plt.axvline(25, color='k', linewidth=1)#, ls='dashed')
    plt.axvline(30, color='k', linewidth=1)#, ls='dashed')
    #plt.axvspan(25, 30, color='red', alpha=0.05)
    #plt.axvspan(30, 60, color='red', alpha=0.1)
    plt.ylabel('Frequency')
    plt.xlabel('BMI (kg/m$^2$)')
    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    df2, df3 = load_data()
    plot(df2, df3)
