import matplotlib.pyplot as plt
import math
import numpy as np

fig_size = plt.rcParams["figure.figsize"]
fig_size[0] = 15
fig_size[1] = 8

withdraw_subsidy = lambda S, staker_kappa: staker_kappa / staking_rate * np.log(S)
restake = lambda S, staker_kappa: S ** (staker_kappa / staking_rate) - 1.0

staker_kappa = 1.0
kappa_avg = (1.0 + (0.5+(0.5*(1/12)))) / 2  # uniform distribution of stake lock durations - k = 0.77
staking_rate = 0.70 
T12 = 365 * 2
T_modified = T12 / kappa_avg  # actual halving time
I_s = 1002509/1e9
S_P1Max = 1829579800
switch = S_P1Max / (I_s*1e9 * kappa_avg)

def P1plot(staker_kappa, f=None, **kw):
    t = np.linspace(0, switch, 365)
    S = 1 + (I_s * kappa_avg * t)
    subsidy = f(S, staker_kappa)
    plt.plot(t/365, subsidy*100, **kw)

def label():
    # plt.title('Sum of subsidies received')
    plt.xlabel('Time from network launch (years)')
    plt.ylabel('Cumulative subsidy earnings as percentage of stake (%)')

if __name__ == '__main__':
    P1plot(staker_kappa=1.0, f=restake, color='blue', label='restaking, kappa = 1 year+')
    P1plot(staker_kappa=1.0, f=withdraw_subsidy, color='red', label='withdraw subsidy, kappa = 1 year+')
    P1plot(staker_kappa=0.5 * (1 + 1./12), f=restake, color='blue',
         linestyle='--', label='restaking, kappa = 1 month')
    P1plot(staker_kappa=0.5 * (1 + 1./12), f=withdraw_subsidy, color='red',
         linestyle='dotted', label='take compensation, kappa = 1 month')
    plt.title('Phase 1 cumulative subsidy earnings, various stake configurations | Staking rate: 70% | Kappa*: 0.77')    
    label()
    plt.legend(loc='upper left')
    plt.savefig('SubsidyP1.pdf')