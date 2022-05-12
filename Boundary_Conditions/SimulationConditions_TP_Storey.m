%% To generate the data presented in Figure 9 of Eggenhuisen et al. (2022).

function [Wmin,Wmax,Wsteps,Dmin,Dmax,Dsteps,BankAngles,Smin,Smax,Ssteps,Cinmin,Cinmax,Csteps,...
    d50,d90,CurDurmin,CurDurmax,CDsteps,CurFreqmin,CurFreqmax,CFsteps,...
    SystActmin,SystActmax,SAsteps] = SimulationConditions

% Flow dynamic properties
Wmin=200*0.9;          Wmax=200*1.1;         Wsteps = 6;     % ChannelWidth [m] - min, max and steps
Dmin=2.5   ;           Dmax=6.5;           Dsteps = 6;     % Channel Depth [m] - min, max and steps
BankAngles = [10 10];                                   % Enter angles as degrees - program later converts them to raidians
Smin=0.7;          Smax=0.9;           Ssteps = 6;    	% Slope [degree] - min, max and steps
Cinmin=0.2;         Cinmax=0.6;         Csteps = 6;     % Initial average sediment conentration [Volume %] - min, max and steps
d50 = 2e-4;         d90 = 4e-4;                         % d50 (static bed) and d90 (mobile bed) grainsize [m] for bed roughness ### Build in a safety for the case z0>Deltay ###
                                            % Maximum sediment concentration in a granular shear layer at the bed
% Flow duration/frquency properties
CurDurmin= 3;      CurDurmax= 6;      CDsteps = 6  ;   	% Turbidity Current Duration [hours] - min, max and steps
CurFreqmin=0.0999;       CurFreqmax= 0.1001;	CFsteps = 2;    % Frequency of turbidity currents [#/year] - min, max and steps
SystActmin=4.999;   SystActmax= 5.001;	SAsteps = 2;	% Geological system activity [kyr] - min, max and steps
