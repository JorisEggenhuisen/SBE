# SBE
Sediment Budget Estimator for deep sea depositional systems

## Info

This is version 1.0.0 of the Sediment Budget Estimator (SBE), which quantifies flow structure (velocity & sediment concentration) and sediment flux for turbidity currents flowing down submarine channels and canyons, and integrates this over time to estimate the sediment budget of a parameterised deep sea depositional system. The model is described in the publication:

Eggenhuisen, J.T., Tilston, M.C., Stevenson, C.J., Hubbard, S.M., Cartigny, M.J.B., Heijnen, M.S., de Leeuw, J., Pohl, F., and Spychala, Y.T. (2021) The Sediment Budget Estimator (SBE): a process-model for the stochastic estimation of fluxes and budgets of sediment through submarine channel systems. EarthArXiv, https://doi.org/10.31223/X5FK6K. 

Please cite the code as: 
J.T. Eggenhuisen, & M.C. Tilston. (2022). Sediment Budget Estimator for deep marine depositional systems (1.0.0). Zenodo. https://doi.org/10.5281/zenodo.6635519 
[![DOI](https://zenodo.org/badge/485391707.svg)](https://zenodo.org/badge/latestdoi/485391707)

## Set-up

The SBE is written to be executed in Matlab. Version 1.0.0 has been tested up to MATLAB [R2019a0]. It makes use of the function 'percentile', which is part of the Statistics Toolbox. The SBE consists of 5 -.m files:

-Run_SBE.m Is the script that executes the Sediment Budget Estimator.
-SimulationConditions.m The boundary condition ranges for the desired simulations are specified here.
-SimParamaters.m Declares some standard parameters and constants.
-VelCon.m This function returns the velocity and concentration profiels and the sediment flux.
-FlowDur.m This function returns the sediment budget.

Auxiliary -.m files:

- The folder 'Boundary Conditions' contains versions of 'SimulationConditions.m' that can be used to reproduce the results of Eggenhuisen et al. (2021).
- The folder 'Visualisations' contains example code that was use to produce the figures in Eggenhuisen et al. (2021). 

## Author information 

The Matlab code for the SBE was written by Joris Eggenhuisen & Mike Tilston. See Eggenhuisen et al. (2021) for a complete list of contributors to the scientific process.

## Potential Improvements 

Development potential:
- Facilitate single-flow parameterisation (deterministic instead of stochastic)
- Facilitate non-uniform sampling of boundary condition ranges (e.g. normal or log-normal distributions) 
- Auto-adjust 'steps' parameter to the boundary condition range.

## Changelog

A changelog file is available that documents the changes made between different versions.

## THE END (but hopefully TO BE CONTINUED)
