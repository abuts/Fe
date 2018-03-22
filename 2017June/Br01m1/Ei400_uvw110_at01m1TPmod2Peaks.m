function Ei400_uvw110_at01m1TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [0,1,-1];
dE = 10;
dK = 0.05;




repPoints1= [-0.22,-0.06,0,0.16,0.28;
    50,15,0,25,100];
repPoints2 = [-0.23,-0.06,0,0.13,0.23;
    75,15,0,15,80];
repPoints3 = [-0.24,-0.03,0,0.13,0.29;
    60,15,0,20,90];
repPoints4 = [-0.24,-0.11,0,0.13,0.29;
    65,15,0,20,85];
repPoints5 = [-0.24,-0.08,0,0.11,0.29;
    45,15,0,15,95];
repPoints6 = [-0.23,-0.11,0,0.13,0.26;
    50,20,0,15,90];


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
