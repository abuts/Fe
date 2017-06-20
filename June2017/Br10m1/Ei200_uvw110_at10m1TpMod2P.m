function Ei200_uvw110_at101TpMod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');

bragg = [1,0,1];
dE = 5;
dK = 0.05;


repPoints1= [-0.24,-0.09,0,0.09,0.29;
    60,10,0,10,85];
repPoints2 = [-0.24,-0.09,0,0.11,0.29;
    60,10,0,10,85];
repPoints3 = [-0.23,-0.09,0,0.09,0.24;
    60,10,0,10,70];
repPoints4 = [-0.24,-0.09,0,0.09,0.31;
    55,10,0,10,90];
repPoints5 = [-0.26,-0.09,0,0.09,0.24;
    75,10,0,10,70];
repPoints6 = [-0.26,-0.09,0,0.11,0.26;
    70,10,0,10,75];
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,1,0],dE,dK);
rp2 = parWithCorrections(repPoints2,bragg,[1,-1,0],dE,dK);
rp3 = parWithCorrections(repPoints3,bragg,[1,0,1],dE,dK);
rp4 = parWithCorrections(repPoints4,bragg,[1,0,-1],dE,dK);
rp5 = parWithCorrections(repPoints5,bragg,[0,1,1],dE,dK);
rp6 = parWithCorrections(repPoints6,bragg,[0,1,-1],dE,dK);

repP={rp6,rp5,rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,0>',repP)

