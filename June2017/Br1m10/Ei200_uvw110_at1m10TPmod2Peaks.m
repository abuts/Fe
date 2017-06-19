function Ei200_uvw110_at1m10TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root,'sqw','Data','Fe_ei200.sqw');

avrg_par=[0,0,957.9503];
bragg = [1,-1,0];
dE = 5;
dK = 0.05;



repPoints1= [-0.29,-0.1,0,0.15,0.3;
    110,15,0,15,110];
repPoints2 = [-0.29,-0.04,0,0.23,0.33;
    85,10,0,75,125];
repPoints3 = [-0.3,-0.08,0,0.08,0.34;
    100,10,0,10,115];
repPoints4 = [-0.3,-0.04,0,0.09,0.37;
    100,10,0,10,120];
repPoints5 = [-0.36,-0.1,0,0.06,0.3;
    120,10,0,10,100];
repPoints6 = [-0.34,-0.08,0,0.07,0.32;
    120,10,0,10,100];
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,1,0],dE,dK);

% #2
rp2 = parWithCorrections(repPoints2,bragg,[1,-1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[1,0,1],dE,dK);

% #4
rp4 = parWithCorrections(repPoints4,bragg,[1,0,-1],dE,dK);

% #5
rp5 = parWithCorrections(repPoints5,bragg,[0,1,1],dE,dK);

% #6
rp6 = parWithCorrections(repPoints6,bragg,[0,1,-1],dE,dK);

repP={rp2,rp1,rp3,rp4,rp5,rp6};

do_fits(data_source,bragg,'<1,1,0>',repP)

