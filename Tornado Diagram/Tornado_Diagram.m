
%% create tornado plots for SBE sensitivity analyses and scenario comparissons, as in Figures 4, 8, & 10 of Eggenhuisen et al. (2022).

% generate and load data

names={ 'High Concentration',...
    'Broad Concentration', ...
    'Low Concentration'}; % Write the names of scenarios or parameter groups that ar eto be compared

% load all the percentiles for the different simulations, one by one from
% SBE result workspaces. This step has not been automated 

PercSedBudSens=zeros(length(names),101);  % create a matrix that will contain all percentiles of the cases named in 'names'. 

Classe=1;
PercSedBudSens(Classe,:)=SimResults.PercSedBud; % assign data from a simulation to row 'Classe' of PercSedBudSens

%sort increasing concentration and sediment budgests

MaxX=max(PercSedBudSens(:,91)); % to be used to set the xlimits

sPercSedBudSens(1,:)=PercSedBudSens(3,:); % some sorting in a different order; use [B,I] = sort(PercSedBudSens) to sort longer scenarios from small to large.
sPercSedBudSens(2,:)=PercSedBudSens(2,:);
sPercSedBudSens(3,:)=PercSedBudSens(1,:);
snames=names;
snames{1}=names{3};
snames{3}=names{1}; % sorting done

% Initialise the  empty figure

figure

PI=NaN(size(sPercSedBudSens)); % No data to initiate the empty plot with space for all categories

b=barh(PI(:,1),'BaseValue',7e10,... % plot single dummy bar per category use 70 km^3 as a BaseLine for Grand Banks
        'FaceColor','none',...
        'EdgeColor','none');
   
set(gca, 'yticklabel', snames,...
    'xlim', [0 1.1*MaxX]);   %attribute variable names to tick marks and set x-axis limits.

b(1).BaseLine.Color = 'k' ; 
b(1).BaseLine.LineStyle = '--' ; 
b(1).BaseLine.LineWidth = 1 ; 

ax=gca; %get the axes properties.
ax.FontSize=12; %sets the fontsize to 12
ax.LineWidth = 1;
ax.XLabel.String='Sediment Budget [m^3]';
ax_pos=ax.Position; % onbtain the position of the first axis drawn

% now draw the percentile data ranges one by one

for j=1:length(snames)
    P=NaN(size(sPercSedBudSens));
    P(j,:)=sPercSedBudSens(j,:); % P now contains NaNs except in row j
    
    %plot the bars for this category
    
    % First copy the axes properties to new axes
    New_ax=axes('Position',ax_pos, 'Color', 'none' ); %  

    % And try to draw the bar plot for the base case
    bv=sPercSedBudSens(j,51);

    incr=0.9/39; % increments in gray scale

    for i=91:-1:51; % plot the upper pecentiles
        step=(i-1)-50;
        kleur=incr*step;
        b1=barh(P(:,i),'Parent',New_ax,'BaseValue',bv,...% I have to tell it here to plot this in the ax1 plot
            'FaceColor',[kleur kleur kleur],...
            'EdgeColor',[kleur kleur kleur]);
        hold on
    end
    for i=11:1:49; % plot the lower pecentiles
        step=50-(i+1);
        kleur=incr*step;
        b1=barh(P(:,i),'BaseValue',bv,...
            'FaceColor',[kleur kleur kleur],...
         'EdgeColor',[kleur kleur kleur]);
        hold on
    end

    %attribute variable names to tick marks and set x-axis limits.
    set(gca, 'yticklabel', '',... % text is allready plotted
        'xticklabel', ' ',...   % text is allready plotted
        'xlim', [0 1.1*MaxX],...
        'color', 'none');   % make the plotbox transparent
    
    %add axis title for sediment budget.
   
    b1(1).BaseLine.Color = 'none' ; % b is the handle for the current bar plot makes the baseline disappear
         
    ax=gca; %get the axes properties.
    ax.FontSize=12; %sets the fontsize to 12
    ax.LineWidth = 1;
    ax.XLabel.String='Sediment Budget [m^3]';
    ax.XLabel.Color='none'; % these steps are used to make the axes exactly overlap.
        
end % done plotting the tornado diagram

%% clear some variables, it is worth saving teh workspace with 'names' and 'PercSedBudSens' only

%clear SimResults
%clear incr step i kleur Classe bv
%clear PercSedBudSens names

clearvars -except PercSedBudSens names 

