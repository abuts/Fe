function Ei400_uvw100_at101TpMod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,0,1];
dE = 10;
dK = 0.05;


repPoints1= [-0.24,-0.11,0,0.11,0.36;
    80,20,0,20,140];

repPoints2 = [-0.31,-0.18,0,0.13,0.31;
    115,30,0,15,115];
repPoints3 = [-0.34,-0.11,0,0.09,0.29;
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

repP={rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,0,0>',repP)

