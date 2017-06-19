function Ei200_uvw100_at200TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root,'sqw','Data','Fe_ei200.sqw');
bragg = [2,0,0];
dE = 5;
dK = 0.05;

avrg_par=[0,0,949.35];

repPoints1 = [-0.33,-0.11,0,0.11,0.36;
    120,15,0,10,155];

repPoints2=[-0.31,-0.08,0,0.11,0.36;
    140,10,0,10,140];
repPoints3=[-0.33,-0.09,0,0.09,0.36;
    140,15,0,15,140];


% Cuts
% #1
rp1=parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);

% #2
rp2=parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3=parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,0,0>',repP)



