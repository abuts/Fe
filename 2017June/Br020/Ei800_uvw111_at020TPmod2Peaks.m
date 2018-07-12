function Ei800_uvw111_at020TPmod2Peaks(varargin)

root_folder = pwd;
this_fldr = fileparts(root_folder);
data_source= fullfile(this_fldr,'sqw','Data','Fe_ei787.sqw');

bragg = [0,2,0];
dE = 5;
dK = 0.1;

pefP1= [-0.625,-0.125,0,0.125,0.625;
    260,35,0,35,360];
pefP2 = [-0.625,-0.125,0,0.125,0.625;
    260,50,0,50,360];
pefP3 = [-0.625,-0.075,0,0.175,0.525;
    340,50,0,50,290];
pefP4 = [-0.675,-0.025,0,0.175,0.575;
    365,50,0,50,290];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP = {rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
