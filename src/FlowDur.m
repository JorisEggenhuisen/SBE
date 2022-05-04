function [SedBud]=FlowDur_SBE_GUI(SimConds,SimResults)

% Loads flow duration simulation conditions
CurDurmin = SimConds.CurDurmin;      CurDurmax = SimConds.CurDurmax;      CDsteps = SimConds.CDsteps;  % Loads current discharge parameters
CurFreqmin = SimConds.CurFreqmin;  	CurFreqmax = SimConds.CurFreqmax;	CFsteps = SimConds.CFsteps;  % Loads current frequency parameters
SystActmin = SimConds.SystActmin;   	SystActmax = SimConds.SystActmax;	SAsteps = SimConds.SAsteps;  % Loads system activation parameters
Qsed = SimResults.Qsed;

% Creates the range of values used in flow duration simulations
CurDur= (CurDurmin:(CurDurmax-CurDurmin)/CDsteps:CurDurmax)';       % Sets the durations for the simulations
CurDur=CurDur*3600;                                                 % Conversion from hours to seconds
CurFreq= (CurFreqmin:(CurFreqmax-CurFreqmin)/CFsteps:CurFreqmax)';	% Sets the frequency for the simulations
SystAct= (SystActmin:(SystActmax-SystActmin)/SAsteps:SystActmax)';	% Sets the system activity for the simulations
SystAct=SystAct.*1e3;                                               % Conversion of system activity to year
[CurDur, CurFreq, SystAct] = ndgrid(CurDur, CurFreq, SystAct);     	% Gets all possible combinations for the simulation
CurDur = CurDur(:); CurFreq = CurFreq(:); SystAct = SystAct(:);     % Converts output to columns
Combs = CurDur'.* CurFreq'.*SystAct';                               % Multiplies all flow duration properties
SedBud = repmat(Qsed,size(Combs)).*repmat(Combs,size(Qsed));        % Calculates the sediment budget
SedBud = SedBud(:);                                                 % Converts the results to column format
end
