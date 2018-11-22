===================
CosmoChord
===================
:CosmoChord:  PolyChord + CosmoMC for cosmological parameter estimation and evidence calculation
:Author: Will Handley
:ForkedFrom: https://github.com/cmbant/CosmoMC
:Homepage: http://polychord.co.uk

.. image:: https://travis-ci.org/williamjameshandley/CosmoChord.svg?branch=master
    :target: https://travis-ci.org/williamjameshandley/CosmoChord

Description and installation
=============================

CosmoChord is a fork of `CosmoMC <https://github.com/cmbant/CosmoMC>`__, which
adds nested sampling provided by PolyChord.

Installation procedure:

.. bash::
   
   git clone https://github.com/williamjameshandley/CosmoChord
   cd CosmoChord
   make
   export OMP_NUM_THREADS=1
   ./cosmomc test.ini

Changes
=======
You can see the key changes by running:

.. bash::
   git remote add upstream https://github.com/cmbant/CosmoMC
   git fetch upstream
   git diff --stat upstream/master
   git diff  upstream/master source 
   git diff  upstream/master camb 


The changes to CosmoMC are minor:

- Nested sampling heavily samples the tails of the posterior. This means that
  there need to be more corrections for these regions that are typically
  unexplored by the default metropolis hastings tool.
- You should **not** use openmp parallelisation, as this in inefficient when
  using PolyChord. Instead, you should use pure MPI parallelisation, and you
  may use as many cores as you have live points.
