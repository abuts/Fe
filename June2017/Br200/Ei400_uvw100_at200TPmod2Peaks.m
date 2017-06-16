function Ei400_uvw100_at200TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [2,0,0];
dE = 10;
dK = 0.1;


repPoints1= [-0.32,-0.125,0,0.18,0.48;
    180,25,0,30,250];

repPoints2 = [-0.43,-0.125,0,0.175,0.48;
    225,30,0,25,220];
repPoints3 = [-0.39,-0.11,0,0.14,0.46;
    215,25,0,25,220];


% Cuts
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)

