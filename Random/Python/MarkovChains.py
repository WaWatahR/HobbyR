# -*- coding: utf-8 -*-
"""
Created on Sat Feb  4 14:24:38 2017

@author: WAllworth
"""

import numpy as np

A = np.array([[.5, -.5], [-.5, 1]])
b = np.array([1, 1])
X = np.linalg.solve(A, b)
print('Expected number of steps from state 0: ' + str(X[0]))

# Simulate the calculation above
sims = 10000
flips = list()

for i in range(1, sims):
    j = 1
    cont = 1
    sim_result = list()
    while cont == 1:
        test = np.random.choice(['H', 'T'], size=1, replace=True, p=None)
        sim_result.append(test)
        if(j > 1):
            if((sim_result[j-2] == 'H') & (sim_result[j-1] == 'H')):
                flips.append(j)
                cont = 0
        j = j + 1
round(np.mean(flips), 0)
