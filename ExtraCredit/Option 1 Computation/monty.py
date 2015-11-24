import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import random

#1. The Monty Hall Problem: If you’re unfamiliar with this problem, please see
#the following video (http://www.youtube.com/watch?v=9vRUxbzJZ9Y).
#I want you to write R syntax that will simulate this scenario, such that a
#person selects a choice of 1 in 3 doors (behind one of which is a prize), and
#is given the opportunity to switch their selection when given information about
#one of the remaining doors that does not contain the prize. Your syntax should
#show how often the person would win if they stayed with their original
#selection, and how often they will win if they switch their selection after
#seeing that one of the remaining doors is not a winner. As we’re always
#interested in large number statistics, you should compare the winning frequency
#for either strategy (staying vs. switching) when a person is confronted with
#this situation once, 10 times, 100 times, 500 times, and 1,000 times in a row.
#Further, we should probably see what these outcomes look like at each number of
#trials 500 times (i.e., one trial outcomes 500 times, 10 trial outcomes 500
#times, etc.). Once this is complete graph the average outcome for each trial
#size (one, 10, 100, etc.) with error bars; you should graph the outcomes for
#staying and switching for comparison.


def monty(contestant_switches=False, verbose=False):
    def logging(verbose):
        if verbose:
            return print
        else:
            return lambda x: None
    verbose = logging(verbose)

    # There are three doors
    doors = range(3)

    # The 'host' picks one to hide the car
    brand_new_car = random.choice(doors)
    verbose("The brand new car is hiding behind door {}.".format(brand_new_car))

    # The contestant chooses a door at random
    contestant_choice = random.choice(doors)
    verbose("The contestant chooses door {}.".format(contestant_choice))

    # Host must next show a door to the contestant
    possible_reveal_doors = list(doors)

    # Host will not show the brand new car
    possible_reveal_doors.remove(brand_new_car)

    # Host will also not show the contestant's choice
    try:
        possible_reveal_doors.remove(contestant_choice)
    except ValueError:
        # This error occurs when the contestant has chosen the new car
        pass

    # The host then picks a random door from the remaining choices
    door_revealed = random.choice(possible_reveal_doors)
    verbose("The host reveals door {}.".format(door_revealed))

    # The remaining door is left standing
    remaining_door = list(doors)
    remaining_door.remove(door_revealed)
    remaining_door.remove(contestant_choice)

    # Does the contestant switch?
    results = np.array([contestant_choice, remaining_door.pop()])
    if contestant_switches:
        switched = 1
        verbose("The contestant switches to door {}.".format(results[switched]))
    else:
        switched = 0
        verbose("The contestant doesn't switch.")

    # Does the contestant win?
    if results[switched] == brand_new_car:
        verbose("The contestant wins!")
    else:
        verbose("The contestant loses!")
    return results == brand_new_car

res = []
confrontations = [1, 10, 100, 500, 1000]
for num_confrontation in confrontations:
    for _ in range(500):
        df = pd.DataFrame([monty() for _ in range(num_confrontation)],
                          columns=['no_switch', 'switch']).mean().to_dict()
        df['confrontations'] = num_confrontation
        res.append(df)
df = pd.DataFrame(res)
df.groupby('confrontations').no_switch.plot.kde()
plt.legend()
plt.show()

normalized = []
for num_confrontation in confrontations:
    t = df.query('confrontations == @num_confrontation')
    t = (t - t.mean()) / t.std()
    t['confrontations'] = num_confrontation
    normalized.append(t)
norm = pd.concat(normalized)
norm.groupby('confrontations').no_switch.plot.kde()
plt.legend()
plt.show()

#df = pd.melt(df, id_vars=['confrontations'])
#sns.factorplot(x='confrontations', y='value', hue='variable', data=df)

# I should make this plot
#https://upload.wikimedia.org/wikipedia/commons/0/0c/Monty_problem_monte_carlo.svg
