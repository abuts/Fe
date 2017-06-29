function Ei200_uvw111_at101TpMod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');


bragg = [1,0,1];
dE =5;
dK =0.05;


pefP1 = [-0.24,-0.09,0,0.09,0.29;
    65,10,0,10,80];
pefP2 = [-0.24,-0.1,0,0.11,0.29;
    60,10,0,10,85];
pefP3 = [-0.24,-0.09,0,0.1,0.29;
    60,10,0,10,85];
pefP4 = [-0.26,-0.11,0,0.1,0.29;
    65,10,0,10,80];
    

rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP={rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
