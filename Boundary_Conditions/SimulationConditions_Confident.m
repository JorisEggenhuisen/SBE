%% To generate the data presented in Figure 11A of Eggenhuisen et al. (2022).

function [Wmin,Wmax,Wsteps,Dmin,Dmax,Dsteps,BankAngles,Smin,Smax,Ssteps,Cinmin,Cinmax,Csteps,...
    d50,d90,CurDurmin,CurDurmax,CDsteps,CurFreqmin,CurFreqmax,CFsteps,...
    SystActmin,SystActmax,SAsteps] = SimulationConditions


% Flow dynamic properties
Wmin=300*0.9;          Wmax=300*1.1;         Wsteps = 6;     % ChannelWidth [m] - min, max and steps
Dmin=15*0.9 ;           Dmax=15*1.1;           Dsteps = 6;     % Channel Depth [m] - min, max and steps
BankAngles = [10 10];                                   % Enter angles as degrees - program later converts them to raidians
Smin=1.75*0.9;          Smax=1.75*1.1;           Ssteps = 6;    	% Slope [degree] - min, max and steps
Cinmin=0.4*0.9;         Cinmax=0.4*1.1;         Csteps = 6;     % Initial average sediment conentration [Volume %] - min, max and steps
d50 = 150e-6;         d90 = 350e-6;                         % d50 (static bed) and d90 (mobile bed) grainsize [m] for bed roughness ### Build in a safety for the case z0>Deltay ###

% Flow duration/frquency properties
CurDurmin= 3*0.9;      CurDurmax= 3*1.1;      CDsteps = 8  ;   	% Turbidity Current Duration [hours] - min, max and steps
CurFreqmin=0.075*0.9;       CurFreqmax= 0.075*1.1;	CFsteps = 8;    % Frequency of turbidity currents [#/year] - min, max and steps
SystActmin=7.5*0.9;   SystActmax= 7.5*1.1;	SAsteps = 8;	% Geological system activity [kyr] - min, max and steps
