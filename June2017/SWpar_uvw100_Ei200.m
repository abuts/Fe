function SWpar_uvw100_Ei200()
% Calculate SW parameters from range of specific cuts.
%-------------------------------------------------
% Parameters :
%
data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');
cuts = containers.Map;


bragg = [1,1,0];  % selected bragg
dE = 5;
dK = 0.05;
repPoints1 = [-0.2625,-0.1125,0,0.1375,0.3625;
    95,19,0,19,123];

repPoints2= [-0.2875,-0.0875,0,0.1375,0.3375;
    95,15,0,19,121];
repPoints3 = [-0.3125,-0.1125,0,0.1375,0.25;
    109,21,0,19,84];

cuts('[110]')= {parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK),...
    parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK),...
    parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK)};

bragg = [1,-1,0];  % selected bragg
dE = 5;
dK = 0.05;
repPoints1 = [-0.2625,-0.0875,0,0.2875,0.3375;
    95,17,0,67,121];
repPoints2= [-0.3375,-0.2625,0,0.0875,0.3125;
    123,73,0,13,97];
repPoints3 = [-0.3375,-0.1125,0,0.0875,0.3125;
    109,13,0,13,109];

cuts('[1-10]')= {parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK),...
    parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK),...
    parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK)};

bragg = [2,0,0];  % selected bragg
dE = 5;
dK = 0.05;
repPoints1 = [-0.275,-0.075,0,0.175,0.375;
    123,15,0,19,153];

repPoints2=[-0.3375,-0.1875,0,0.1875,0.3375;
    123,31,0,27,137];
repPoints3=[-0.31,-0.12,0,0.12,0.35;
    140,20,0,20,140];

cuts('[200]')= {parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK),...
    parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK),...
    parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK)};


cuts_blocks = prepare_cuts_map(data_source,cuts);
[~,fname] = fileparts(data_source);
[en_sw,S_sw,S_sw_err,Gamma,Gamma_err] = ...
    refine_sw_parameters(cuts_blocks,fname,'!100!');

figure('Name','Spin wave amplitude along <100> direction');
errorbar(en_sw,S_sw,S_sw_err);
ly(0, 2.5)
figure('Name','Spin wave lifetime along <100> direction');
errorbar(en_sw,Gamma,Gamma_err);
ly(0,80);



