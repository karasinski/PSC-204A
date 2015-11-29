import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_style('white')
plt.style.use('fivethirtyeight')


def dice(A, X, n=1):
    ''' Generate n instances of an AdX dice roll.'''

    return np.random.randint(low=1, high=X+1, size=(n, A))


def throw(AdX, n=1, success_min=None, botching=False, stats=False, plot=False):
    '''
    Throw dice with optional repetitions, minimum value for success, and
    botching.
    '''

    # Pull the values for your roll.
    A, X = np.array(AdX.split('d'), dtype=int)

    if n == 1 and success_min is None:
        # Just the results of the dice roll.
        if A == 1:
            return dice(A, X)[0][0]
        else:
            return dice(A, X).sum()
    elif success_min is None:
        # Statistics on the result of many dice rolls.
        scores = dice(A, X, n).sum(axis=1)
    elif success_min and not botching:
        # Statistics of the results of many dice rolls with a minimum value for
        # success.
        scores = (dice(A, X, n) >= success_min).sum(axis=1)

        # Just the number of successes for this roll.
        if n == 1:
            return scores[0]
    elif botching:
        # Statistics of the results of many dice rolls with a minimum value for
        # success and the possibility of botching.
        d = dice(A, X, n)
        d[d == 1] = -1
        d[np.logical_and(d > 0, d < success_min)] = 0
        d[d > 0] = 1
        scores = d.sum(axis=1)
        scores[scores < 0] = -1
        if n == 1:
            return scores[0]
    else:
        raise ValueError('Sorry, these values are not supported.')

    if plot:
        filename = AdX
        if success_min: filename += '_min' + str(success_min)
        if botching: filename += '_botching'
        statistics(scores, plot=True, filename=filename)
    if stats:
        return statistics(scores)

    return scores


def statistics(scores, plot=False, filename=False):
    # Generate the statistics.
    s = pd.Series(scores).value_counts().reset_index()
    s.columns = ['Value', 'Count']
    s['Frequency'] = s['Count']/s['Count'].sum() * 100
    s = s.sort('Value')

    if plot:
        sns.countplot(scores, order=np.unique(scores))
        plt.xlabel('Value')
        plt.ylabel('Count')
        plt.tight_layout()
        if filename:
            plt.savefig(filename + '.pdf')
        else:
            plt.show()
        plt.close('all')
    return s


def main():
    # %timeit throw('1d20')
    # 100000 loops, best of 3: 10.4 µs per loop

    # %timeit throw('2d6')
    # 100000 loops, best of 3: 15.4 µs per loop

    # %timeit throw('4d10', success_min=5)
    # 10000 loops, best of 3: 20.4 µs per loop

    # %timeit throw('4d10', success_min=5, botching=True)
    # 10000 loops, best of 3: 32.3 µs per loop

    print('a. Roll 1d6 1,000 times, frequency of each outcome?\n')
    print(throw('1d6', n=1000, plot=True, stats=True))

    print('b. Roll 2d6 1,000 times, frequency of each outcome? Use the summed scores of each die as your outcome.\n')
    print(throw('2d6', n=1000, plot=True, stats=True))

    print('c. Roll 6d10 1,000 times, frequency of each outcome? Treat a score of 6 or better as a success and scores less than 6 as nothing, the outcome is total number of successes (include the frequency of no successes).\n')
    print(throw('6d10', n=1000, success_min=6, plot=True, stats=True))

    print('d. Same as (c) above except now scores of 1 count as a botch. Each botch is subtracted from each success. If there are more botches than success (i.e., -1 successes) then the overall outcome is a botch. Now depict the frequency of botching, and total number of successes (as before, include the frequency of no successes).\n')
    print(throw('6d6', n=1000, success_min=6, botching=True, plot=True, stats=True))

if __name__ == '__main__':
    main()
