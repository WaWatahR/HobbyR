# -*- coding: utf-8 -*-
"""
Created on Sat Feb  4 16:03:47 2017

@author: WAllworth
"""
import matplotlib.pyplot as mp
from scipy.integrate import ode
import numpy as np

def A():
    '''
    Transition probability matrix
    '''
    return np.array([[-.1,.1,0], [.1,-.2,.1], [0,.1,-.1]])

def dPdt(t,P,A):
    '''
    Differential equation: dP/dt = A * P
    '''
    return np.dot(P,A())

def solveKFW(Tf):
    '''
    Discretize and integrate the Kolmogorov
    Forward Equation.
    '''
    
    #Define initial conditions
    P0 = np.array([1,0,0])
    t0 = 0
    dt = Tf/100
    
    #set the integrator
    rk45 = ode(dPdt).set_integrator('dopri5')
    rk45.set_initial_value(P0,t0).set_f_params(A)
    
    #integrate and store each solution in
    #a numpy matrix, P and T.
    P = np.zeros((100,3))
    T = np.zeros(100)
    P[0,:] = P0
    T[0]   = t0
    idx    = 0
    while rk45.successful() and rk45.t < Tf:
        rk45.integrate(rk45.t+dt)
        P[idx,:] = np.array(rk45.y)
        T[idx]   = rk45.t
        idx     += 1
    
    return P,T
    
if __name__=='__main__':
    P,T = solveKFW(120)
    
    mp.plot(T,P[:,0],'s-r')
    mp.plot(T,P[:,1],'^-g')
    mp.plot(T,P[:,2],'*-k')
    mp.legend(['Inactive A','Active, B', 'Inactive, C'])
    mp.xlabel('Time (m)')
    mp.ylabel('Pr of state, s')