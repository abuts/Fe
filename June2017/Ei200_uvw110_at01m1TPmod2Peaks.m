function Ei200_uvw110_at01m1TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [0,1,-1];
dE = 5;
dK = 0.05;


repPoints1= [-0.15,-0.07,0,0.12,0.3;
    30,10,0,15,65];
repPoints2 = [-0.23,-0.09,0,0.9,0.22;
    45,10,0,10,50];
repPoints3 = [-0.15,-0.07,0,0.1,0.27;
    35,10,0,10,60];
repPoints4 = [-0.18,-0.07,0,0.09,0.24;
    40,10,0,10,55];
repPoints5 = [-0.18,-0.07,0,0.1,0.26;
    35,10,0,1,55];
repPoints6 = [-0.18,-0.07,0,0.07,0.26;
    40,10,0,10,50];
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

repP={rp6,rp5,rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,0>',repP)

