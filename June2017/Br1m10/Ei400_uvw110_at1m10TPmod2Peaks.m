function Ei400_uvw110_at1m10TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,-1,0];
dE = 10;
dK = 0.05;



repPoints1= [-0.34,-0.16,0,0.2,0.38;
    160,15,0,30,160];
repPoints2 = [-0.31,-0.1,0,0.1,0.45;
    120,15,0,15,195];
repPoints3 = [-0.36,-0.11,0,0.11,0.42;
    145,20,0,20,185];
repPoints4 = [-0.35,-0.09,0,0.15,0.43;
    145,15,0,15,185];
repPoints5 = [-0.4,-0.1,0,0.12,0.34;
    175,15,0,20,150];
repPoints6 = [-0.39,-0.1,0,0.09,0.36;
    180,15,0,20,140];


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
