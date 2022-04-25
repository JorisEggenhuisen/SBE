# SBE
Sediment Budget Estimator for deep sea depositional systems

## Info

This is version 1.0.0 of the Sediment Budget Estimator (SBE), which quantifies flow structure (velocity & sediment concentration) and sediment flux for turbidity currents flowing down submarine channels and canyons, and integrates this over time to estimate the sediment budget of a parameterised deep sea depositional system. The model is described in the publication:

Eggenhuisen [et al with https DOI link.] 

## Set-up

The SBE is written to be executed in Matlab. Version 1-0 has been tested up to MATLAB [R2019a0]. It makes use of the function 'percentile', which is part of the Statistics Toolbox. The SBE consists of 5 -.m files:

-m.files list + explanation

Auxiliary -.m files:

- The folder 'Boundary Conditions' contains versions of 'SimulationConditions.m' that can be used to reproduce the results of Eggenhuisen et al. (2022).
- The folder 'Visualisations' contains example codes that was use to produce teh figures in Eggenhuisen et al. (2022). 

## Author information 

The Matlab code for the SBE was written by Joris Eggenhuisen & Mike Tilston. See Eggenhuisen et al. (2022) for a complete list of contributors to the scientific process.

## Potential Improvements 

Major development themes:
- Facilitate single-flow parameterisation (deterministic instead of stochastic)
- Record specific boundary conditions used for each individual result stored in the SimResults.s structure
- Facilitate non-uniform sampling of boundary condition ranges (e.g. normal or log-normal distributions) 

Code, syntax, bugs:
- Modernise and simplify code for data-structure initiation
- Auto-adjust 'steps' parameter to the boundary condition range.

## Changelog

A changelog file is available that documents the changes made between different versions.

## THE END (but hopefully TO BE CONTINUED)
