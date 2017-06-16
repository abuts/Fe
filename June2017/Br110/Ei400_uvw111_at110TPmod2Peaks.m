function Ei400_uvw111_at110TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,1,0];
dE = 10;
dK = 0.05;

pefP1= [-0.36,-0.16,0,0.13,0.41;
    130,25,0,20,190];
pefP2 = [-0.38,-0.12,0,0.1438,0.4063;
    160,20,0,25,165];
pefP3 = [-0.41,-0.14,0,0.1,0.4;
    165,25,0,20,160];
pefP4 = [-0.42,-0.14,0,0.16,0.42;
    165,25,0,25,165];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP = {rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
