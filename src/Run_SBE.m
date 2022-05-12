clear % start with a clear workspace

%% Loads simulation constants
[rhow, rhos, g, muw, vuw, kappa, Cmax] = SimParameters;  % Loads in the parameters 

%%%%%%%%%%%%%%%%%%%%% POPULATES THE STRUCTURED ARRAY %%%%%%%%%%%%%%%%%%%%%%
SimParams.rhow = rhow;	% Density of water [kg/m3]
SimParams.rhos = rhos;   % Density of Quartz [kg/m3]
SimParams.muw = muw;     % Dynamic viscosity of water at T=10C [Pas; Ns/m2; kg/ms]; note 1.0e-3 for T=20C
SimParams.vuw = vuw;     % Kinematic vicosity of water at T=20C [m2/s]
SimParams.g = g;         % Acceleration by gravity [m/s2]
SimParams.kappa = kappa; % von Karman constant [-]
SimParams.Cmax = Cmax;   % Maximum sediment concentration in a granular shear layer at the bed; ### Move to SimParameters.m

clearvars -except SimParams %Clean up the workspace;

%% Loads simulation conditions
[Wmin,Wmax,Wsteps,Dmin,Dmax,Dsteps,BankAngles,Smin,Smax,Ssteps,Cinmin,Cinmax,Csteps,...
    d50,d90,CurDurmin,CurDurmax,CDsteps,CurFreqmin,CurFreqmax,CFsteps,...
    SystActmin,SystActmax,SAsteps] = SimulationConditions;  % Loads in the simulation conditions

%%%%%%%%%%%%%%%%%%%%% POPULATES THE STRUCTURED ARRAY %%%%%%%%%%%%%%%%%%%%%%
SimConds.Wmin = Wmin;            SimConds.Wmax = Wmax;            SimConds.Wsteps = Wsteps;
SimConds.Dmin = Dmin;            SimConds.Dmax = Dmax;            SimConds.Dsteps = Dsteps;
SimConds.BankAngles = BankAngles;
SimConds.Smin = Smin;            SimConds.Smax = Smax;            SimConds.Ssteps = Ssteps;
SimConds.Cinmin = Cinmin;      	SimConds.Cinmax = Cinmax;        SimConds.Csteps = Csteps;
SimConds.d50 = d50;              SimConds.d90 = d90;
SimConds.CurDurmin = CurDurmin;	SimConds.CurDurmax = CurDurmax;	SimConds.CDsteps = CDsteps;
SimConds.CurFreqmin = CurFreqmin;SimConds.CurFreqmax =CurFreqmax;SimConds.CFsteps = CFsteps;
SimConds.SystActmin = SystActmin;SimConds.SystActmax = SystActmax;SimConds.SAsteps = SAsteps;

clearvars -except SimParams SimConds %Clean up the workspace;

%% Runs the simulation

    [D,Deltay,ybed,Ubed,Cbed,ush, Csat, Qsed]...
                = VelCon(SimParams,SimConds);     % Runs the flow dynamics function; "interp" variables no longer used
    SimResults.D = D;
    SimResults.Deltay = Deltay;
    SimResults.z = ybed;
    SimResults.U = Ubed;
    SimResults.C = Cbed.*100; %Save as volume percentage
    SimResults.Ush=ush;
    Simresults.Csat=Csat;
    SimResults.Qsed = Qsed;  
        [SedBud]=FlowDur(SimConds,SimResults);% Runs the flow duration function
    SimResults.SedBud = SedBud;
        PercSedBud=[NaN 1:1:99 NaN];
        PercSedBud(1)=min(SimResults.SedBud);
        PercSedBud(2:100)=prctile(SimResults.SedBud,PercSedBud(2:100));
        PercSedBud(101)=max(SimResults.SedBud);
    SimResults.PercSedBud=PercSedBud;
        PercQsed=[NaN 1:1:99 NaN];
        PercQsed(1)=min(SimResults.Qsed);
        PercQsed(2:100)=prctile(SimResults.Qsed,PercQsed(2:100));
        PercQsed(101)=max(SimResults.Qsed);
    SimResults.PercQsed=PercQsed;
  
clearvars -except SimParams SimConds SimResults; %Clean up the workspace;

%% Plots the results

LineW = 1; % Width of lines
nbars = 100; % number of bars used in the histograms

vectmax=[1:1:size(SimResults.U,1)]; %look for a representative scenario for plotting purposes, take maximum velocity as metric
for j=1:size(SimResults.U,1)
vectmax(j)=max(SimResults.U(j,:));
end
Mean=mean(vectmax);
[~,indec]=find((abs(vectmax-Mean))==min(abs(vectmax-Mean))); % finds all scenarios with the minimum difference to the average maximum velocity of all scenarios.

figure

%%%%%%%%%%%%%%%%%%% PLOTS THE VELOCITY STRUCTURE %%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,2,1)

xLine = SimResults.U(indec(1),:);
yLine = SimResults.z(indec(1),:);
VelLine = plot(xLine,yLine, 'color','k',...
    'LineWidth',LineW,'XDataSource','xLine','YDataSource','yLine',...
    'Parent',gca);

hold (gca, 'on');

plot([0 1.2*max(SimResults.U(indec(1),:))],[ (SimConds.Dmin+SimConds.Dmax)./2 (SimConds.Dmin+SimConds.Dmax)./2 ],'k:'); % the average channel depth for reference

xlim([0 1.2*max(SimResults.U(indec(1),:))]);
ylim([0 SimResults.z(indec(1),230)]);

xlabel(gca,'Velocity [m/s]');
ylabel(gca,'Height [m]');

%%%%%%%%%%%%%%%%%%% PLOTS THE DENSITY STRUCTURE %%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,2,2)

xLine = SimResults.C(indec(1),:);
yLine = SimResults.z(indec(1),:);
ConcLine = plot(xLine,yLine,'color','k',...
    'LineWidth',LineW,'XDataSource','xLine','YDataSource','yLine',...
    'Parent',gca);

hold (gca,'on')

plot([0 SimParams.Cmax(1).*100],[ (SimConds.Dmin+SimConds.Dmax)./2 (SimConds.Dmin+SimConds.Dmax)./2 ],'k:')

xlim([0 1.2.*max(SimResults.C(indec(1,:)))]);
ylim([0 SimResults.z(indec(1),230)]);

xlabel(gca,'Volume concentration sediment [%]');
ylabel(gca,'Height [m]');

%%%%%%%%%%%%%%%%%%%%% PLOTS THE SEDIMENT FLUX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,2,3)

h=histogram(SimResults.Qsed, nbars,'FaceColor', 'k', 'Normalization', 'probability','FaceAlpha',1);

xlim([0 1.2*max(SimResults.Qsed(:))]);
ylim([0 1.2*max(h.Values)]);

xlabel(gca,'Sediment flux [m^3/s]');
ylabel(gca,'Probability [-]');

hold on

plot([SimResults.PercQsed(51) SimResults.PercQsed(51)], [0 1.2.*max(h.Values)],'w',...
    [SimResults.PercQsed(11) SimResults.PercQsed(11)], [0 1.2.*max(h.Values)],'w:',...
    [SimResults.PercQsed(91) SimResults.PercQsed(91)], [0 1.2.*max(h.Values)],'w:'); % Plots the median, d10 and d90 in vertical white (dotted) lines over the histogram.

hold off

%%%%%%%%%%%%%%%%%%%% PLOTS THE SEDIMENT BUDGET %%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,2,4)

h=histogram(SimResults.SedBud,nbars,'FaceColor', 'k', 'Normalization', 'probability','FaceAlpha',1);

xlim([0 1.2*max(SimResults.SedBud(:))]);
ylim([0 1.2*max(h.Values)]);

xlabel(gca,'Sediment Budget [m^3]');
ylabel(gca,'Probability [-]');

hold on 

plot([SimResults.PercSedBud(51) SimResults.PercSedBud(51)], [0 1.2.*max(h.Values)],'w',...
    [SimResults.PercSedBud(11) SimResults.PercSedBud(11)], [0 1.2.*max(h.Values)],'w:',...
    [SimResults.PercSedBud(91) SimResults.PercSedBud(91)], [0 1.2.*max(h.Values)],'w:'); % Plots the median, d10 and d90 in vertical white (dotted) lines over the histogram.

hold off

%% Clean up the workspace; disable or modify when extra variables or parameters are of interest to be retained.

clearvars -except SimParams SimConds SimResults SedQHisto SedBudHisto
