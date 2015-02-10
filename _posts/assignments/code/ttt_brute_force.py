"""
Computes _all_ possible games of tic-tac-toe, and returns the percentage of
wins, losses, and draws, relative to the starting player: X.
"""
from collections import Counter
from functools import reduce
import itertools as it

from multiprocessing import Pool
import sys

## Permutation code taken from http://stackoverflow.com/a/6285203/890705
class unique_element:
    def __init__(self,value,occurrences):
        self.value = value
        self.occurrences = occurrences

def perm_unique(elements):
    eset=set(elements)
    listunique = [unique_element(i,elements.count(i)) for i in eset]
    u=len(elements)
    return perm_unique_helper(listunique,[0]*u,u-1)

def perm_unique_helper(listunique,result_list,d):
    if d < 0:
        yield tuple(result_list)
    else:
        for i in listunique:
            if i.occurrences > 0:
                result_list[d]=i.value
                i.occurrences-=1
                for g in  perm_unique_helper(listunique,result_list,d-1):
                    yield g
                i.occurrences+=1

def runs(board):
    return [
        board[0:3:1], board[3:6:1], board[6:9:1],
        board[0:7:3], board[1:8:3], board[2:9:3],
        board[0:9:4], board[2:6:2]
    ]

def run_outcome(run):
    if None in run:
        return None
    elif run == ['x', 'x', 'x']:
        return 'win'
    elif run == ['o', 'o', 'o']:
        return 'lose'
    else:
        return 'draw'

def board_outcome(board):
    outcomes = Counter(map(run_outcome, runs(board)))

    wins   = outcomes['win' ]
    losses = outcomes['lose']
    draws  = outcomes['draw']
    empty  = outcomes[None  ]

    if wins+losses > 1:
        return None
    elif wins == 1:
        return 'win'
    elif losses == 1:
        return 'loss'
    elif empty > 0:
        return None
    else:
        return 'draw'

pieces9 = ['x', 'x', 'x', 'x', 'x', 'o', 'o', 'o', 'o'] + [None]*0
pieces8 = ['x', 'x', 'x', 'x',      'o', 'o', 'o', 'o'] + [None]*1
pieces7 = ['x', 'x', 'x', 'x',      'o', 'o', 'o'     ] + [None]*2
pieces6 = ['x', 'x', 'x',           'o', 'o', 'o'     ] + [None]*3
pieces5 = ['x', 'x', 'x',           'o', 'o'          ] + [None]*4

pieces = [pieces9, pieces8, pieces7, pieces6, pieces5]

def compute(n_proc):
    pool = Pool(n_proc)
    
    all_possible_boards = it.chain(*map(perm_unique, pieces))
    all_possible_outcomes = pool.imap_unordered(board_outcome,
                                                all_possible_boards)

    counts = Counter(all_possible_outcomes)

    wins   = counts['win' ]
    losses = counts['lose']
    draws  = counts['draw']
    empty  = counts[None  ]

    total_count = wins + losses + draws + empty

    p_win  = wins   / total_count
    p_lose = losses / total_count
    p_draw = draws  / total_count

    print("W: {}, L: {}, D: {}".format(p_win, p_lose, p_draw))

    return 0

if __name__ == "__main__":
    n_proc = int(sys.argv[1])
    exit(compute(n_proc))
