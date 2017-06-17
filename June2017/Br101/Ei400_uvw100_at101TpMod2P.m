function Ei400_uvw100_at101Tpmod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,0,1];
dE = 10;
dK = 0.05;


repPoints1= [-0.31,-0.09,0,0.16,0.33;
    110,20,0,25,120];

repPoints2 = [-0.39,-0.08,0,0.09,0.24;
    145,15,0,15,80];
repPoints3 = [-0.36,-0.13,0,0.09,0.31;
    120,20,0,20,105];


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

