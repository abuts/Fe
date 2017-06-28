function Ei200_uvw111_at10m1TpMod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');


bragg = [1,0,-1];
dE =5;
dK =0.05;


pefP1 = [-0.24,-0.09,0,0.09,0.31;
    60,10,0,10,85];
pefP2 = [-0.24,-0.09,0,0.09,0.29;
    65,15,0,15,85];
pefP3 = [-0.24,-0.11,0,0.14,0.31;
    65,15,0,15,80];
pefP4 = [-0.24,-0.09,0,0.1,0.29;
    60,15,0,15,85];
    

rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP={rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
