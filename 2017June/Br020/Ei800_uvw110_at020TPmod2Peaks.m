function Ei800_uvw110_at020TPmod2Peaks(varargin)
% Does not work -- too few points to fit around [1,-1,0]
%
root_folder = pwd;
this_fldr = fileparts(root_folder);
data_source= fullfile(this_fldr,'sqw','Data','Fe_ei787.sqw');

bragg = [0,2,0];
dE = 5;
dK = 0.1;

refP1= [-0.675,-0.075,0,0.175,0.575;
    260,50,0,50,325];
refP2 = [-0.575,-0.025,0,0.275,0.525;
    325,50,0,50,275];
refP3 = [-0.775,-0.075,0,0.175,0.675;
    325,50,0,50,325];
refP4 = [-0.675,-0.025,0,0.225,0.675;
    310,50,0,50,325];
refP5 = [-0.625,-0.125,0,0.075,0.575;
    260,50,0,50,360];
refP6 = [-0.625,-0.175,0,0.075,0.625;
    260,50,0,50,380];


rp1 = parWithCorrections(refP1,bragg,[1,1,0],dE,dK);
rp2 = parWithCorrections(refP2,bragg,[1,-1,0],dE,dK);
rp3 = parWithCorrections(refP3,bragg,[1,0,1],dE,dK);
rp4 = parWithCorrections(refP4,bragg,[1,0,-1],dE,dK);
rp5 = parWithCorrections(refP5,bragg,[0,1,1],dE,dK);
rp6 = parWithCorrections(refP6,bragg,[0,1,-1],dE,dK);

repP={rp6,rp5,rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,0>',repP)
