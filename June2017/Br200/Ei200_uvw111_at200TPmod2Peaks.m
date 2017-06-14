function Ei200_uvw111_at200TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root,'sqw','Data','Fe_ei200.sqw');

bragg = [2,0,0];
dE =5;
dK =0.05;


pefP1 = [-0.33,-0.08,0,0.08,0.42;
    130,10,0,10,150];
pefP2 = [-0.34,-0.08,0,0.13,0.38;
    130,15,0,15,150];
pefP3 = [-0.33,-0.1,0,0.1,0.4;
    130,10,0,10,150];
pefP4 = [-0.32,-0.08,0,0.1,0.4;
    130,10,0,10,150];
    

rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP={rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
