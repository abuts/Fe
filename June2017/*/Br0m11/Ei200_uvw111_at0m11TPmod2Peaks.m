function Ei200_uvw111_at0m11TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');


bragg = [0,-1,1];
dE =5;
dK =0.05;


pefP1 = [-0.29,-0.1,0,0.1,0.24;
    85,10,0,10,60];
pefP2 = [-0.27,-0.07,0,0.1,0.26;
    80,10,0,10,65];
pefP3 = [-0.23,-0.08,0,0.1,0.3;
    60,10,0,10,85];
pefP4 = [-0.26,-0.08,0,0.08,0.29;
    65,10,0,10,80];
    

rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP={rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
