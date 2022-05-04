function [D,Deltay,ybed,Ubed,Cbed,ush,Csat,Qsed]...
        = VelCon_SBE_GUI(SimParams,SimConds)
    
% This first portion of the function serves as a shell for all the SBE
% calculations. See the sub-routines at the end of the function to see the 
% specifics of all the nested calculations for each parameter.

%% Gets the data needed for subsequent calculations from the GUI
rhow = SimParams.rhow;           rhos = SimParams.rhos;           g = SimParams.g;
vuw = SimParams.vuw;             kappa = SimParams.kappa;        
Cmax = SimParams.Cmax;            d50 = SimConds.d50;              d90 = SimConds.d90;

%% Creates the total number of variable combinations used in flow dynamics simulations
[W,D,S,Cin] = FlowDynamicCombs_SBE_GUI(SimConds);

%% Calculates cross-sectional geometry (Assumes trapazoid geometry)
BankAngles = pi.*(SimConds.BankAngles)./180;	% These are the bank angles with respect to the bed (converted from degrees to radians)
[H,Hbed,Hbanks,Wbed,Wbanks,Dbed,Dbanks]=ChannelGeom_SBE_GUI(W,D,BankAngles);

%% Removes simulations where bed width is less than zero
disp '-------------------------------------------------'
disp(['Anticipated number of simulations: ',num2str(length(Wbed))])
GoodSims = find(Wbed>=0);
Cin = Cin(GoodSims);
D = D(GoodSims);        Dbanks = Dbanks(GoodSims,:);        Dbed = Dbed(GoodSims);
H = H(GoodSims);        Hbanks = Hbanks(GoodSims,:);        Hbed = Hbed(GoodSims);
S = S(GoodSims);
W = W(GoodSims);        Wbanks = Wbanks(GoodSims,:);        Wbed = Wbed(GoodSims);
disp(['Calculate number of simulations: ',num2str(length(Wbed))])
disp '-------------------------------------------------'

%% Calculation of shear velocity and sediment saturation
[ush,Csat] = Ush_SBE_GUI(rhow,rhos,g,vuw,Cmax,Cin,S,H);
[ush_bed,Csat_bed] = Ush_SBE_GUI(rhow,rhos,g,vuw,Cmax,Cin,S,Hbed);
[ush_banks,Csat_banks] = Ush_SBE_GUI(rhow,rhos,g,vuw,Cmax,Cin,S,Hbanks);

%% Calculation of y0 - considers hydraulically smooth, transitional, and rough flows and mobile beds
[y0] = y0_SBE_GUI(vuw,rhow,rhos,g,d50,d90,ush);              % Calculates for the total cross-sectional area
[y0bed] = y0_SBE_GUI(vuw,rhow,rhos,g,d50,d90,ush_bed);       % Calculates for the bed panel
[y0banks] = y0_SBE_GUI(vuw,rhow,rhos,g,d50,d90,ush_banks);   % Calculates for the bank panels

%% Construct y-coordinate vector [z is used in the text of Eggenhuisen et al.]
Deltay = 0.01;                              % the stepsize of the vertical coordinate as afraction of D
Deltay = Deltay:Deltay:2.5;                 % creates a vector of non-dimensional depth increments
[y,ulog] = Ulog_SBE_GUI(D,Deltay,y0);                       % Calculates for the total cross-sectional area
[ybed,ulogbed] = Ulog_SBE_GUI(Dbed,Deltay,y0bed);           % Calculates for the bed panels
[ybanks,ulogbanks] = Ulog_SBE_GUI(Dbanks,Deltay,y0banks);	% Calculates for the bank panels

%% Construct mixing layer velocity profile (Plane Mixing Layer following Pope Chapter 5.X)
Ul = 0;                                     % Velocity of quiescent environment = ambient fluid
[Uh,Us,FxsiPML,UPML] = UPML_SBE_GUI(Ul,Deltay,y,y0,D);	% Calculates for the total cross-sectional area
[Uhbed,Usbed,FxsiPMLbed,UPMLbed] =...
    UPML_SBE_GUI(Ul,Deltay,ybed,y0bed,Dbed);            % Calculates for the bed panels
[Uhbanks,Usbanks,FxsiPMLbanks,UPMLbanks] =...
    UPML_SBE_GUI(Ul,Deltay,ybanks,y0banks,Dbanks);      % Calculates for the bank panels

%% Calculates the full velocity profile
[U,Uwake] = Ustruct_SBE_GUI(kappa,Deltay,ush,ulog,...
    Uh,Us,FxsiPML,UPML);                            % Calculates for the total cross-sectional area; Eq. 1 in Eggenhuisen et al.
[Ubed,Uwakebed] = Ustruct_SBE_GUI(kappa,Deltay,ush_bed,ulogbed,...
    Uhbed,Usbed,FxsiPMLbed,UPMLbed);                % Calculates for the bed panel; Eq. 1 in Eggenhuisen et al.
[Ubanks,Uwakebanks] = Ustruct_SBE_GUI(kappa,Deltay,ush_banks,ulogbanks,...
    Uhbanks,Usbanks,FxsiPMLbanks,UPMLbanks);        % Calculates for the bank panels; Eq. 1 in Eggenhuisen et al.

%% Calculates the concentration profile
[C] = Cstruct_SBE_GUI(Deltay,D,y,Cin,Csat); % Calculates for the total cross-sectional area
[Cbed] = Cstruct_SBE_GUI(Deltay,Dbed,ybed,Cin,Csat_bed); % Calculates for the total cross-sectional area
[Cbanks] = Cstruct_SBE_GUI(Deltay,Dbanks,ybanks,Cin,Csat_banks); % Calculates for the total cross-sectional area

%% Calculates the sediment discharge 
[Qsedbed] = Qsed_SBE_GUI(Deltay,ybed,Ubed,Cbed,Wbed);
[Qsedbanks] = Qsed_SBE_GUI(Deltay,ybanks,Ubanks,Cbanks,Wbanks); % both margins are included here
Qsed = sum([Qsedbed,Qsedbanks],2); % Opting for the trapazoid cross-section as the preferred geometry

end % declare end of the velocity and concentration profile function

function [W,D,S,Cin] = FlowDynamicCombs_SBE_GUI(SimConds)
% Loads flow dynamics simulation conditions
Wmin = SimConds.Wmin;        Wmax = SimConds.Wmax;        Wsteps = SimConds.Wsteps; % Loads width parameters
Dmin = SimConds.Dmin;        Dmax = SimConds.Dmax;        Dsteps = SimConds.Dsteps; % Loads depth parameters
Smin = SimConds.Smin;        Smax = SimConds.Smax;        Ssteps = SimConds.Ssteps; % Loads slope parameters
Cinmin = SimConds.Cinmin;	Cinmax = SimConds.Cinmax;    Csteps = SimConds.Csteps; % Loads concentration parameters

% Creates the range of values used in flow dynamics simulations
W = (Wmin:(Wmax-Wmin)/Wsteps:Wmax)';        % Sets widths for simulations
D = (Dmin:(Dmax-Dmin)/Dsteps:Dmax)';        % Sets depths for simulations
S = tand((Smin:(Smax-Smin)/Ssteps:Smax)');  % Sets slopes for simulations and converts from degrees to tangent
Cin = ((Cinmin:(Cinmax-Cinmin)/Csteps:Cinmax)')./100;    % Sets concentrations for simulations and converts from [%] to fraction [-]
[W, D, S, Cin] = ndgrid(W, D, S, Cin);      % Gets all possible combinations of the input parameters for the simulation
W = W(:); D = D(:); S = S(:); Cin = Cin(:); % Converts all possible combinations of input parameters into column format
end

function [H,Hbed,Hbanks,Wbed,Wbanks,Dbed,Dbanks] = ChannelGeom_SBE_GUI(W,D,BankAngles)
Dbanks = [D,D]./2;          Dbed = D;       % These are the depths of the banks and the bed % JTE margin and thalweg sections
Wbanks = [Dbed/tan(BankAngles(1)),Dbed/tan(BankAngles(2))];     % This is the width of the banks % margin sections
WPbanks = [Dbed./sin(BankAngles(1)),Dbed./sin(BankAngles(2))];	% This is the wetted perimeter of the banks % margin sections
Wbed = W-Wbanks(:,1)-Wbanks(:,2);  % JTE This is the width of the thalweg section
WPbed = Wbed;% This is the wetted perimeter of the bed % of the thalweg section, before taking friction with the ambient fluid into account
AREAbanks = Wbanks.*Dbanks;                 % This is the cross-sectional area of the banks % JTE of the margin sections
AREAbed = Wbed.*Dbed;                     	% This is the cross-sectional area of the bed % JTE of the thalweg section
H = sum([AREAbed,AREAbanks],2)./...
    sum([W,WPbed,WPbanks],2);               % Modified hydraulic radius to account for friction between the current and the ambient fluid %JTE Is H used for anything, or are al calculations with Hbed and Hbanks?
Hbed = AREAbed./(WPbed.*2);                	% Modified hydraulic radius for the bed pannel
Hbanks = AREAbanks./(WPbanks+Wbanks);       % Modified hydraulic radius for the bank pannels
end

function [ush,Csat] = Ush_SBE_GUI(rhow,rhos,g,vuw,Cmax,Cin,S,H)
R = (rhos-rhow)./rhow;                      % relative specific density of sediment in water
ush = sqrt( g.* R.* repmat(Cin,1,size(H,2)).*...
    H.* repmat(S,1,size(H,2)));             % the shear velocity with Eq. 8 from Section 2.2 in Eggenhuisen et al.
Csat = ush.^3./(140.*vuw.*g.*R);            % the saturated near-bed sediment concentration following Eggenhuisen et al. 2017; Equation 7 from Section 2.2 in Eggenhuisen et al.
Csat(Csat>Cmax) = Cmax;                     % prevent the near-bed concentration from being larger than the maximum granular shear concentration.
end

function [y0] = y0_SBE_GUI(vuw,rhow,rhos,g,d50,d90,ush)
R = (rhos-rhow)./rhow;                      % relative specific density of sediment in water
if d90<2e-3; ks=3*d90;                        % Nikuradse sand roughness as advised by van Rijn 2011
else ks=d90+4e-3; end                        % Gravel roughness increases slower with grainsize, as advised by van Rijn 2011
% Calculation of y0 for non-mobile beds - models roughtness for hydraulically smooth, transitional, and rough flows - Christofferson and Jonsson (1985) - eqn 2-27 in Garcia
y0 = ks./30.*(1-exp((-ush.*ks)./(27.*vuw)))+vuw./(9.*ush);
% Calculation of y0 for mobile beds - This models roughness for mobile beds (Dietrich and Whitting, 1989 - eqn 2-32b in Garcia)
y0n = (ks./30);                             % Roughness value for non-mobile bed - assumes hydraulically rough
alpha_1 = 0.077;                            % Empirical constant
if d50<2e-3, psi = 33; else psi = 40; end    % Friction angle of sediment
tau_b = rhow.*ush.^2;                       % This is the bed shear stress 
R_ep = ush.*d50./vuw;                       % Shields particle number
tau_cstar = 0.22.*R_ep.^(-0.6)+0.06*...
    exp(-17.77.*R_ep.^(-0.6)) ;             % This is the dimensionless critical stress (Brownlie,1981) - eqn 2-59a in Garcia
tau_c = tau_cstar.*rhow.*g.*R.*d50;         % Critical shear stress.
y_bl = (1.2*d50.*(1-cosd(psi)).*(tau_b./tau_c))./...
    (1+0.2.*(tau_b./tau_c));                % Bedload layer height (eqn 2-32c in Garcia)
y0MB = alpha_1.*y_bl+y0n;                   % y0 for mobile beds (Dietrich and Whitting, 1989 - eqn 2-32b in Garcia) - MB used to denote mobile bed
% Determines whether mobile or non-mobile values of y0 should be used
y0(tau_b>=tau_c) = y0MB(tau_b>=tau_c);
end

function [y,ulog] = Ulog_SBE_GUI(D,Deltay,y0)
Deltay = sort(repmat(Deltay,1,size(D,2)));      % y values alternate between the two banks (when banksare calculated
y = repmat(D,1,size(Deltay,2)./size(D,2)).*...
    repmat(Deltay,size(D,1),1);                 % Gets the depths for each scenario
yD = y;                                         % Temporary depth values for the total cross-sectional area
D_mat = repmat(D,1,size(Deltay,2)./size(D,2));	% Temporary depth values for the total cross-sectional area
yD(yD>D_mat) = D_mat(yD>D_mat);                 % Replaces points above D with D
ulog = log(yD./repmat(y0,1,size(Deltay,2)./size(D,2)));% Logarithmic velocity profile for the total cross-sectional area

end

function [Uh,Us,FxsiPML,UPML] = UPML_SBE_GUI(Ul,Deltay,y,y0,D)
z=y;                                        % The vertical coordinate of the mixing layer
Uh = log(D./y0);                            % Velocity of jet = turbidity current
Us = Uh-Ul;                                 % Characteristic velocity difference
Uc = 0.5.*(Uh+Ul);                          % Characteristic convection velocity;equal to Uhalf in turbidity currents
delta = D;                                  % Characteristic width of mixing layer; equal to flow thickness see Pope Fig 5.24, delta spans from xsiPML=-0.5 to +0.5
zref = D;                                   % The elevation of Uhalf at the center of the mixing layer in a turbidity current
xsiPML = (z-repmat(zref,size(Deltay)))./...
    repmat(delta,size(Deltay));             % Scaled coordinate for Plane Mixing Layer Eq. 4 in Eggenhuisen et al.
sigma = 1./(2.*sqrt(2).*erfinv(4./5));      % Pope Eq. 5.226 = 0.3902
FxsiPML = 0.5.*erf(xsiPML./(sigma.*sqrt(2)));% Scaled velocity function Pope Eq. 5.224 Eq. 3 in Eggenhuisen et al.
% UPML= (FxsiPML.*Us)+Uc; % velocity of Plane Mixing Layer Pope Eq. 5.231; Eq. 5 in Eggenhuisen et al.
UPML = repmat(Uc,size(Deltay))-...
    (FxsiPML.*repmat(Us,size(Deltay)));% MIKE CORRECTION TO THE ABOVE EQUATION
end

function [U,Uwake] = Ustruct_SBE_GUI(kappa,Deltay,ush,ulog,Uh,Us,FxsiPML,UPML)
% Finally the parameterisation with shear velocity and the von Karman constant; Eq. 1 in Eggenhuisen et al.
U = (repmat(ush,size(Deltay))./kappa).*...
    (ulog-(repmat(Uh,size(Deltay))-UPML));
% Calculates the profile from the wake law
PI = Us./4;
omega = -2.*FxsiPML;
Uwake = (repmat(ush,size(Deltay))./kappa).*...
    (ulog-(2.*repmat(PI,size(Deltay)).*(1-omega)));
end

function [C] = Cstruct_SBE_GUI(Deltay,D,y,Cin,Csat)
k = Csat./(repmat(Cin,1,size(D,2)).*D); % Determine decay constant k  - Eq. 10 in Section 2.3 of Eggenhuisen et al.
C = repmat(Csat,size(Deltay)).*exp(repmat(-k,size(Deltay)).*y); % see Eq. 6 in Section 2.1 of Eggenhuisen et al.
end


function [Qsed] = Qsed_SBE_GUI(Deltay,y,U,C,W)

% The apparent weird indexing needs to be maintained due to the structure of
% the bank data % JTE because size(Qsed,2)= 2 due to the two banks

Qsed = NaN(size(W));
Yzeros = zeros(size(W));
for j = 1:size(Qsed,2)    
    Ydata = y(:,j:size(Qsed,2):end);
    Ydata = Ydata-[Yzeros(:,j),Ydata(:,1:end-1)]; % basically your non-normalized y deltas
    Udata = U(:,j:size(Qsed,2):end);
    Cdata = C(:,j:size(Qsed,2):end);
    Qdata = Udata.*Ydata;
    Qsed(:,j) = dot(Qdata,Cdata,2);
end

Qsed = Qsed.*W; % The sediment discharge rate through the channel cross section in [m^3/s] % W the width of the channel section only here (W_bed or W_banks)
end
