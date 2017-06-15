function Ei200_uvw111_at0m11TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');


bragg = [0,1,-1];
dE =5;
dK =0.05;


pefP1 = [-0.16,-0.07,0,0.09,0.25;
    30,10,0,15,60];
pefP2 = [-0.20,-0.07,0,0.12,0.23;
    35,10,0,15,55];
pefP3 = [-0.2,-0.07,0,0.1,0.2;
    50,10,0,10,50];
pefP4 = [-0.19,-0.07,0,0.09,0.24;
    40,10,0,10,50];
    

rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP={rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
