function Ei200_uvw110_at101Tpmod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');

bragg = [1,0,1];
dE = 5;
dK = 0.05;


repPoints1= [-0.3,-0.09,0,0.1,0.25;
    85,10,0,10,60];
repPoints2 = [-0.25,-0.09,0,0.1,0.28;
    60,10,0,10,85];
repPoints3 = [-0.28,-0.09,0,0.09,0.25;
    75,10,0,10,70];
repPoints4 = [-0.25,-0.07,0,0.13,0.28;
    70,10,0,10,80];
repPoints5 = [-0.29,-0.09,0,0.08,0.24;
    85,10,0,10,55];
repPoints6 = [-0.27,-0.08,0,0.09,0.25;
    70,10,0,10,60];
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

repP={rp1,rp2,rp6,rp5,rp4,rp3};

do_fits(data_source,bragg,'<1,1,0>',repP)

