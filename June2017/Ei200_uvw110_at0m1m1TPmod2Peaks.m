function Ei200_uvw110_at0m1m1TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [1,1,0];
dE = 5;
dK = 0.05;


repPoints1= [-0.3,-0.08,0,0.14,0.35;
    90,10,0,15,125];
repPoints2 = [-0.3,-0.09,0,0.13,0.33;
    105,10,0,15,110];
repPoints3 = [-0.28,-0.08,0,0.11,0.35;
    100,10,0,15,120];
repPoints4 = [-0.31,-0.08,0,0.08,0.34;
    95,10,0,10,115];
repPoints5 = [-0.29,-0.07,0,0.11,0.31;
    100,10,0,10,115];
repPoints6 = [-0.31,-0.11,0,0.07,0.35;
    100,15,0,10,115];
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

