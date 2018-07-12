function Ei800_uvw100_at200TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei787.sqw');
bragg = [2,0,0];


dE = 5;
dK = 0.1;


repPoints1=  [  -0.475   -0.125         0    0.275    0.625;
    240  50    0   50  390];
repPoints2=[-0.525   -0.175         0    0.175    0.575;
    325   35    0   35  340];
repPoints3=[-0.525   -0.175         0    0.175    0.575;
    310.   50,    0   50  310];


% Cuts
% #1

% Cuts
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)



