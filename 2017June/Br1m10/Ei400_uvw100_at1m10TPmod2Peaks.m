function Ei400_uvw100_at1m10TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,-1,0];
dE = 10;
dK = 0.05;


repPoints1= [-0.32,-0.19,0,0.16,0.38;
    135,20,0,25,185];

repPoints2 = [-0.35,-0.14,0,0.14,0.33;
    185,15,0,25,135];
repPoints3 = [-0.36,-0.11,0,0.1,0.35;
    160,15,0,15,160];


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

