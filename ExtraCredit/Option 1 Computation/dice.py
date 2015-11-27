import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


def dice(A, X, n=1):
    ''' Generate n instances of an AdX dice roll.'''

    return np.random.randint(low=1, high=X+1, size=(n, A))


def throw(AdX, n=1, success_min=None, botching=False):
    '''
    Throw dice with optional repetitions, minimum value for success, and
    botching.
    '''

    # Pull the values for your roll.
    A, X = np.array(AdX.split('d'), dtype=int)

    if n == 1:
        # Just the results of the dice roll.
        return dice(A, X)
    elif success_min is None:
        # Statistics on the result of many dice rolls.
        scores = dice(A, X, n).sum(axis=1)
    elif success_min is not None and not botching:
        # Statistics of the results of many dice rolls with a minimum value for
        # success.
        scores = (dice(A, X, n) >= success_min).sum(axis=1)
    elif botching:
        # Statistics of the results of many dice rolls with a minimum value for
        # success and the possibility of botching.
        d = dice(A, X, n)
        d[d == 1] = -1
        d[np.logical_and(d > 0, d < success_min)] = 0
        d[d > 0] = 1
        scores = d.sum(axis=1)
        scores[scores < 0] = -1
    else:
        raise ValueError('Sorry, these values are not supported.')

    # Generate the statistics.
    s = pd.Series(scores).value_counts().reset_index()
    s.columns = ['Value', 'Count']
    s = s.sort('Value')
    return s
