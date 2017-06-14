function Ei200_uvw100_at200TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root,'sqw','Data','Fe_ei200.sqw');
bragg = [2,0,0];
dE = 5;
dK = 0.05;

avrg_par=[0,0,949.35];

repPoints1 = [-0.275,-0.075,0,0.175,0.375;
    125,15,0,20,155];

repPoints2=[-0.3375,-0.1875,0,0.1875,0.3375;
    125,30,0,25,140];
repPoints3=[-0.31,-0.12,0,0.12,0.35;
    140,20,0,20,140];


% Cuts
% #1
rp1=parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);

% #2
rp2=parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3=parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)



