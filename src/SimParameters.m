function [rhow, rhos, g, muw, vuw, kappa, Cmax] = SimParameters

% function to set some often used parameters function call:
%[rhow, rhos, muw, vuw, g, kappa] = parameters; 
%variable names can be anything you want if conflicting with existing variables

rhow=1e3; %density of water [kg/m3]

rhos=2.65e3; %density of (quartz) sediment [kg/m3]

muw=1.3e-3; %dynamic viscosity of water at T=10C [Pas; Ns/m2; kg/ms]; note 1.0e-3 for T=20C

vuw=muw./rhow; %kinematic vicosity of water [m2/s]

g=9.81; % acceleration by gravity [m/s2]

kappa=0.40; % von Karman constant [-]

Cmax=0.585;  % Maximum sediment concentration in a granular shear layer at the bed; ### Move to SimParameters.m
