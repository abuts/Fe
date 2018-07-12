function Ei800_uvw110_at200TPmod2Peaks(varargin)

root_folder = pwd;
this_fldr = fileparts(root_folder);
data_source= fullfile(this_fldr,'sqw','Data','Fe_ei787.sqw');
bragg = [0,2,0];

dE = 5;
dK = 0.1;

refP1= [-0.575,-0.075,0,0.225,0.575;
    260,50,0,50,2750];
refP2 = [-0.575,-0.075,0,0.125,0.525;
    260,50,0,50,290];
refP3 = [-0.575,-0.125,0,0.175,0.575;
    260,35,0,35,275];
refP4 = [-0.625,-0.125,0,0.175,0.625;
    260,50,0,50,360];
refP5 = [-0.575,-0.075,0,0.225,0.625;
    290,50,0,50,325];
refP6 = [-0.525,-0.125,0,0.225,0.725;
    325,50,0,50,325];


rp1 = parWithCorrections(refP1,bragg,[1,1,0],dE,dK);
rp2 = parWithCorrections(refP2,bragg,[1,-1,0],dE,dK);
rp3 = parWithCorrections(refP3,bragg,[1,0,1],dE,dK);
rp4 = parWithCorrections(refP4,bragg,[1,0,-1],dE,dK);
rp5 = parWithCorrections(refP5,bragg,[0,1,1],dE,dK);
rp6 = parWithCorrections(refP6,bragg,[0,1,-1],dE,dK);

repP={rp1,rp2,rp3,rp4,rp5,rp6};

do_fits(data_source,bragg,'<1,1,0>',repP)
