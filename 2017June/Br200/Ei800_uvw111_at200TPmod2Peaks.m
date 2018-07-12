function Ei800_uvw111_at200TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei787.sqw');
bragg = [2,0,0];
dE = 5;
dK = 0.1;

pefP1= [-0.32,-0.125,0,0.225,0.625;
    140,50,0,50,360];
pefP2 = [-0.625,-0.125,0,0.275,0.525;
    260,50,0,50,275];
pefP3 = [-0.575,-0.175,0,0.075,0.625;
    260,35,0,50,275];
pefP4 = [-0.625,-0.125,0,0.125,0.625;
    275,50,0,50,290];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP = {rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
