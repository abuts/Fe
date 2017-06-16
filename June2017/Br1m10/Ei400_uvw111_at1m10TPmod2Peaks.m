function Ei400_uvw111_at1m10TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,-1,0];
dE = 10;
dK = 0.05;

pefP1= [-0.38,-0.11,0,0.16,0.38;
    160,15,0,25,165];
pefP2 = [-0.35,-0.1,0,0.14,0.38;
    160,15,0,20,160];
pefP3 = [-0.32,-0.09,0,0.14,0.44;
    130,15,0,15,190];
pefP4 = [-0.36,-0.1,0,0.09,0.4;
    130,15,0,15,190];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP = {rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
