function Ei400_uvw100_at0m11TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [0,-1,1];
dE = 10;
dK = 0.05;


repPoints1= [-0.26,-0.11,0,0.20,0.33;
    110,15,0,30,120];

repPoints2 = [-0.36,-0.08,0,0.11,0.29;
    145,20,0,20,80];
repPoints3 = [-0.31,-0.11,0,0.11,0.34;
    120,20,0,20,105];


% Cuts
% #1

% Cuts
rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,0,0>',repP)

