function Ei200_uvw110_at110TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root,'sqw','Data','Fe_ei200.sqw');

avrg_par=[0,0,957.9503];
bragg = [1,1,0];
dE = 5;
dK = 0.05;


repPoints1= [-0.2625,-0.0625,0,0.1375,0.3875;
    90,15,0,15,125];
repPoints2 = [-0.3125,-0.1375,0,0.1375,0.3375;
    110,15,0,15,110];
repPoints3 = [-0.2625,-0.0875,0,0.1125,0.3875;
    100,15,0,15,119];
repPoints4 = [-0.3125,-0.0875,0,0.0875,0.3125;
    100,15,0,15,120];
repPoints5 = [-0.3125,-0.0875,0,0.1375,0.3375;
    100,15,0,15,120];
repPoints6 = [-0.3125,-0.0875,0,0.0875,0.3375;
    100,15,0,15,120];
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

repP={rp1,rp2,rp3,rp4,rp5,rp6};

do_fits(data_source,bragg,'<1,1,0>',repP)

