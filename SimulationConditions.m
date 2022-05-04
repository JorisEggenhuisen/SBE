function [Wmin,Wmax,Wsteps,Dmin,Dmax,Dsteps,BankAngles,Smin,Smax,Ssteps,Cinmin,Cinmax,Csteps,...
    d50,d90,CurDurmin,CurDurmax,CDsteps,CurFreqmin,CurFreqmax,CFsteps,...
    SystActmin,SystActmax,SAsteps] = SimulationConditions

% Flow dynamic properties
Wmin=0.95.*390;          Wmax=1.05.*390;         Wsteps = 6;     % ChannelWidth [m] - min, max and steps
Dmin=0.95*60./1.3;           Dmax=1.05*60./1.3;           Dsteps = 6;     % Channel Depth [m] - min, max and steps
BankAngles = [34 17];                                   % Enter angles as degrees - program later converts them to radians
Smin=0.5;          Smax=0.7;           Ssteps = 6;    	% Slope [degree] - min, max and steps
Cinmin=0.95*0.020;         Cinmax=1.05*0.02;         Csteps = 6;     % Initial average sediment conentration [Volume %] - min, max and steps
d50 = 10e-6;         d90 = 200e-6;                         % d50 (static bed) and d90 (mobile bed) grainsize [m] for bed roughness ### Build in a safety for the case z0>Deltay ###

% Flow duration/frquency properties
CurDurmin= 0.95*6.3*24;      CurDurmax= 1.05*6.3*24;      CDsteps = 6;   	% Turbidity Current Duration [hours] - min, max and steps
CurFreqmin=0.999;       CurFreqmax= 1.001;	CFsteps = 6;    % Frequency of turbidity currents [#/year] - min, max and steps
SystActmin=0.999.*1e-3;   SystActmax= 1.001*1e-3;	SAsteps = 6;	% Geological system activity [kyr] - min, max and steps