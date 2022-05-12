%% To generate the data presented in Figures 7 & 8 of Eggenhuisen et al. (2022).

function [Wmin,Wmax,Wsteps,Dmin,Dmax,Dsteps,BankAngles,Smin,Smax,Ssteps,Cinmin,Cinmax,Csteps,...
    d50,d90,CurDurmin,CurDurmax,CDsteps,CurFreqmin,CurFreqmax,CFsteps,...
    SystActmin,SystActmax,SAsteps] = SimulationConditions

% Flow dynamic properties
Wmin=23000*0.9;          Wmax=23000*1.1;         Wsteps = 6;     % ChannelWidth [m] - min, max and steps
Dmin=201.*0.9;           Dmax=201.*1.1;           Dsteps = 6;     % Channel Depth [m] - min, max and steps
BankAngles = [10 10];                                   % Enter angles as degrees - program later converts them to raidians
Smin=0.45*0.9;          Smax=0.45.*1.1;           Ssteps = 6;    	% Slope [degree] - min, max and steps
Cinmin=2.7;         Cinmax=5.4;         Csteps = 8;     % Initial average sediment conentration [Volume %] - min, max and steps
%Cinmin=2.7*0.9;         Cinmax=2.7*1.1;         Csteps = 8;     % Initial average sediment conentration [Volume %] - min, max and steps
%Cinmin=5.4*0.9;         Cinmax=5.4*1.1;         Csteps = 8;     % Initial average sediment conentration [Volume %] - min, max and steps
d50 = 1.25e-3;         d90 = 5e-3;                         % d50 (static bed) and d90 (mobile bed) grainsize [m] for bed roughness ### Build in a safety for the case z0>Deltay ###
                                             % Maximum sediment concentration in a granular shear layer at the bed
% Flow duration/frquency properties
CurDurmin= 4;      CurDurmax= 8;      CDsteps = 8;   	% Turbidity Current Duration [hours] - min, max and steps
CurFreqmin=0.999;       CurFreqmax= 1.001;	CFsteps = 2;    % Frequency of turbidity currents [#/year] - min, max and steps
SystActmin=0.000999;   SystActmax= 0.001001;	SAsteps = 2;	% Geological system activity [kyr] - min, max and steps
