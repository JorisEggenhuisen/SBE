function [Wmin,Wmax,Wsteps,Dmin,Dmax,Dsteps,BankAngles,Smin,Smax,Ssteps,Cinmin,Cinmax,Csteps,...
    d50,d90,CurDurmin,CurDurmax,CDsteps,CurFreqmin,CurFreqmax,CFsteps,...
    SystActmin,SystActmax,SAsteps] = SimulationConditions


% Flow dynamic properties
Wmin=100;          Wmax=500;         Wsteps = 8;     % ChannelWidth [m] - min, max and steps
Dmin=6 ;           Dmax=30;           Dsteps = 8;     % Channel Depth [m] - min, max and steps
BankAngles = [10 10];                                   % Enter angles as degrees - program later converts them to raidians
Smin=0.5;          Smax=2.5;           Ssteps = 8;    	% Slope [degree] - min, max and steps
Cinmin=0.2;         Cinmax=1;         Csteps = 8;     % Initial average sediment conentration [Volume %] - min, max and steps
d50 = 150e-6;         d90 = 350e-6;                         % d50 (static bed) and d90 (mobile bed) grainsize [m] for bed roughness ### Build in a safety for the case z0>Deltay ###

% Flow duration/frquency properties
CurDurmin= 2;      CurDurmax= 10;      CDsteps = 8  ;   	% Turbidity Current Duration [hours] - min, max and steps
CurFreqmin=0.03;       CurFreqmax= 0.15;	CFsteps = 8;    % Frequency of turbidity currents [#/year] - min, max and steps
SystActmin=2;   SystActmax= 10;	SAsteps = 8;	% Geological system activity [kyr] - min, max and steps
