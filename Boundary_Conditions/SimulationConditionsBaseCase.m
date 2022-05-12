%% To generate the data presented in Figures 3 & 11B of Eggenhuisen et al. (2022)

function [Wmin,Wmax,Wsteps,Dmin,Dmax,Dsteps,BankAngles,Smin,Smax,Ssteps,Cinmin,Cinmax,Csteps,...
    d50,d90,CurDurmin,CurDurmax,CDsteps,CurFreqmin,CurFreqmax,CFsteps,...
    SystActmin,SystActmax,SAsteps] = SimulationConditions


% Flow dynamic properties
Wmin=200;          Wmax=400;         Wsteps = 6;     % ChannelWidth [m] - min, max and steps
Dmin=10;           Dmax=20;           Dsteps = 6;     % Channel Depth [m] - min, max and steps
BankAngles = [10 10];                                   % Enter angles as degrees - program later converts them to raidians
Smin=1;          Smax=2.5;           Ssteps = 6;    	% Slope [degree] - min, max and steps
Cinmin=0.2;         Cinmax=0.6;         Csteps = 6;     % Initial average sediment conentration [Volume %] - min, max and steps
d50 = 150e-6;         d90 = 350e-6;                         % d50 (static bed) and d90 (mobile bed) grainsize [m] for bed roughness ### Build in a safety for the case z0>Deltay ###
 
% Flow duration/frquency properties
CurDurmin= 2;      CurDurmax= 4;      CDsteps = 6;   	% Turbidity Current Duration [hours] - min, max and steps
CurFreqmin=0.05;       CurFreqmax= 0.1;	CFsteps = 6;    % Frequency of turbidity currents [#/year] - min, max and steps
SystActmin=5;   SystActmax= 10;	SAsteps = 6;	% Geological system activity [kyr] - min, max and steps
