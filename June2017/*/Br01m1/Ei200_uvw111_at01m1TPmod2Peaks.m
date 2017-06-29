function Ei200_uvw111_at01m1TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');


bragg = [0,1,-1];
dE =5;
dK =0.05;


pefP1 = [-0.15,-0.03,0,0.09,0.29;
    30,10,0,10,65];
pefP2 = [-0.19,-0.07,0,0.1,0.23;
    45,10,0,10,55];
pefP3 = [-0.22,-0.08,0,0.07,0.23;
    50,10,0,10,45];
pefP4 = [-0.2,-0.07,0,0.09,0.22;
    40,10,0,10,50];
    

rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP={rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
