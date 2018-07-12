function Ei400_uvw111_at1m10TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei787.sqw');
bragg = [1,-1,0];
dE = 5;
dK = 0.1;

pefP1= [-0.32,-0.125,0,0.225,0.475;
    140,50,0,50,220];
pefP2 = [-0.3,-0.175,0,0.225,0.475;
    140,50,0,50,220];
pefP3 = [-0.325,-0.125,0,0.175,0.425;
    1550,35,0,35,205];
pefP4 = [-0.325,-0.175,0,0.125,0.425;
    155,35,0,35,205];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP = {rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
