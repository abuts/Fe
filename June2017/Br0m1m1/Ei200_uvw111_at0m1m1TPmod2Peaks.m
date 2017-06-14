function Ei200_uvw111_at0m1m1TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');


bragg = [0,-1,-1];
dE =5;
dK =0.05;


pefP1 = [-0.3,-0.1,0,0.09,0.35;
    100,15,0,10,120];
pefP2 = [-0.3,-0.13,0,0.06,0.36;
    100,15,0,10,120];
pefP3 = [-0.3,-0.11,0,0.06,0.34;
    100,15,0,10,120];
pefP4 = [-0.31,-0.1,0,0.07,0.34;
    100,15,0,10,120];
    

rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP={rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
