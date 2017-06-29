function Ei400_uvw100_at01m1TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [0,1,-1];
dE = 10;
dK = 0.05;


repPoints1= [-0.18,-0.08,0,0.21,0.32;
    55,25,0,30,100];

repPoints2 = [-0.18,-0.11,0,0.11,0.24;
    40,20,0,20,95];
repPoints3 = [-0.26,-0.06,0,0.13,0.26;
    70,15,0,15,85];


% Cuts
% #1

% Cuts
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,0,0>',repP)

