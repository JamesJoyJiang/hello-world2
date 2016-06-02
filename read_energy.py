#!/usr/bin/python
# -*- coding: utf-8 -*-
# This code is written by Mehmet Topsakal (mtopsaka@umn.edu)
# Extracts band structure and total dos information from vasprun.xml
# And saves them to vasprun.mat file which can be loaded by MATLAB
# On DEB based Linux, " sudo apt-get install python-numpy python-scipy python-matplotlib "
# should install required python packages.
# On Mac or Windows, Enthought Canopy should work
# https://store.enthought.com/#canopy-academic


import os
import sys
from   pylab import sqrt
import numpy as np
import scipy.io as sio

c_axis=[]
energy = []
#sys.exit()
aloop=sys.argv
aloop=aloop[1:];
a_loop=[float(aloop[i]) for i in xrange(len(aloop))]
print a_loop,len(a_loop)

os.chdir('Fe_4')
#sys.exit()
for a  in aloop:
    c_axis.append(a) 
    os.chdir('Fe_4_'+a)
    file='OUTCAR'

    with open(file) as f:
      lines = f.readlines()
    for i, line in enumerate(lines):
        if ' FREE ENERGIE OF THE ION-ELECTRON SYSTEM (eV)' in line:
          t = lines[i+4].split()[6];
          aa=float(t)
    energy.append(aa)
    os.chdir('../')
for  i in xrange(len(a_loop)):
  print c_axis[i], energy[i]

sio.savemat('vaspenergy-c_axis.mat', dict(c_axis=c_axis, energy=energy))



