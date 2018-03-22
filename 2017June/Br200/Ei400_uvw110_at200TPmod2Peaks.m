function Ei400_uvw110_at200TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [2,0,0];
dE = 10;
dK = 0.1;



repPoints1= [-0.43,-0.125,0,0.125,0.48;
    195,30,0,20,250];
repPoints2 = [-0.43,-0.18,0,0.18,0.48;
    195,20,0,30,250];
repPoints3 = [-0.43,-0.125,0,0.125,0.48;
    195,20,0,20,245];
repPoints4 = [-0.38,-0.125,0,0.125,0.475;
    145,25,0,25,245];
repPoints5 = [-0.43,-0.125,0,0.125,0.48;
    220,30,0,25,230];
repPoints6 = [-0.42,-0.125,0,0.125,0.480;
    225,30,0,24,230];


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
