function Ei400_uvw100_at110TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,1,0];
dE = 10;
dK = 0.05;


repPoints1= [-0.32,-0.18,0,0.17,0.37;
    140,20,0,30,185];

repPoints2 = [-0.325,-0.125,0,0.175,0.425;
    130,30,0,30,190];
repPoints3 = [-0.375,-0.125,0,0.125,0.375;
    170,20,0,20,170];


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

