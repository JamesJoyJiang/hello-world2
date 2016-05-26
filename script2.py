#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import sys
from   pylab import sqrt
import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt


ymin=-2;
ymax=4.4;



# Read data ------------------------------------------------------ %%%%
os.chdir('step2-bands')
mat_contents = sio.loadmat('vasprun.mat')
bands_up1 = mat_contents['bands_up']
kpoints_path = mat_contents['kpoints_path']; kpoints_path=kpoints_path[0]
efermi1 = mat_contents['efermi']
os.chdir('..')

os.chdir('step3-bands+SO')
mat_contents = sio.loadmat('vasprun.mat')
bands_up2 = mat_contents['bands_up']
efermi2 = mat_contents['efermi']
os.chdir('..')


# Plot data ------------------------------------------------------ %%%%
plt.subplot(1, 1, 1)
for b in range(len(bands_up1)):
  plt.plot(kpoints_path,bands_up1[b]-efermi1[0], 'r-', lw=1, label='Spin-obit off'); # here we only plot spin-up bands for MoS2. Spin-dw is same.


for b in range(len(bands_up2)):
  plt.plot(kpoints_path,bands_up2[b]-efermi2[0], 'b-', lw=1, label='Spin-obit on');



plt.xlim( (  0, max(kpoints_path)) )
plt.ylim( (ymin, ymax) )
plt.xticks([]); 
plt.ylabel('Energy (ev)')
plt.xlabel('$\Gamma$  ------------------------- M -------------- K ------------------------------ $\Gamma$ ')
plt.plot([ 0, max(kpoints_path) ], [ 0, 0 ], 'k-.',linewidth=1) # Fermi line
 
# for vertical lines 
plt.plot([ kpoints_path[50],  kpoints_path[50]  ], [ ymin, ymax ], 'k-', linewidth=0.1) 
plt.plot([ kpoints_path[100],  kpoints_path[100]  ], [ ymin, ymax ], 'k-', linewidth=0.1) 
 
 


# Save as pdf ------------------------------------------------------ %%%%
plt.savefig('plot_python.pdf', format='pdf', dpi=200) 


## uncomment this if you want to get plot window ------------------- %%%%
##plt.show()





