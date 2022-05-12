%% To generate the data presented in Figure 6 of Eggenhuisen et al. (2022).

function [Wmin,Wmax,Wsteps,Dmin,Dmax,Dsteps,BankAngles,Smin,Smax,Ssteps,Cinmin,Cinmax,Csteps,...
    d50,d90,CurDurmin,CurDurmax,CDsteps,CurFreqmin,CurFreqmax,CFsteps,...
    SystActmin,SystActmax,SAsteps] = SimulationConditions

% Flow dynamic properties
Wmin=0.8.*0.9;          Wmax=0.8*1.1;         Wsteps = 6;     % ChannelWidth [m] - min, max and steps
Dmin=0.072.*0.9   ;           Dmax=0.072.*1.1;           Dsteps = 6;     % Channel Depth [m] - min, max and steps
BankAngles = [10 10];                                   % Enter angles as degrees - program later converts them to raidians
Smin=0.9.*11;          Smax=1.1.*11;           Ssteps = 6;    	% Slope [degree] - min, max and steps
Cinmin=0.9*15;         Cinmax=1.1*15;         Csteps = 6;     % Initial average sediment conentration [Volume %] - min, max and steps
d50 = 131e-6;         d90 = 223e-6;                         % d50 (static bed) and d90 (mobile bed) grainsize [m] for bed roughness ### 

% Flow duration/frquency properties
CurDurmin= 80./3600.*0.9;      CurDurmax= 80./3600.*1.1;      CDsteps = 6  ;   	% Turbidity Current Duration [hours] - min, max and steps
CurFreqmin=0.999;       CurFreqmax= 1.001;	CFsteps = 2;    % Frequency of turbidity currents [#/year] - min, max and steps
SystActmin=0.999e-3;   SystActmax= 1.001e-3;	SAsteps = 2;	% Geological system activity [kyr] - min, max and steps

