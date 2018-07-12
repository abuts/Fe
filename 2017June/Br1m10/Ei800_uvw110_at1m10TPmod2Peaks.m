function Ei800_uvw110_at1m10TPmod2Peaks(varargin)
% Does not work -- too few points to fit around [1,-1,0]
%
data_source= fullfile(pwd,'sqw','Data','Fe_ei787.sqw');
bragg = [1,-1,0];
dE = 5;
dK = 0.1;

refP1= [-0.32,-0.18,0,0.275,0.47;
    120,50,0,70,220];
refP2 = [-0.3375,-0.175,0,0.175,0.475;
    150,50,0,50,220];
refP3 = [-0.275,-0.175,0,0.175,0.425;
    140,50,0,50,220];
refP4 = [-0.32,-0.175,0,0.2,0.475;
    140,50,0,50,220];
refP5 = [-0.375,-0.125,0,0.175,0.375;
    170,50,0,50,190];
refP6 = [-0.375,-0.175,0,0.225,0.375;
    170,50,0,50,190];


rp1 = parWithCorrections(refP1,bragg,[1,1,0],dE,dK);
rp2 = parWithCorrections(refP2,bragg,[1,-1,0],dE,dK);
rp3 = parWithCorrections(refP3,bragg,[1,0,1],dE,dK);
rp4 = parWithCorrections(refP4,bragg,[1,0,-1],dE,dK);
rp5 = parWithCorrections(refP5,bragg,[0,1,1],dE,dK);
rp6 = parWithCorrections(refP6,bragg,[0,1,-1],dE,dK);

repP={rp6,rp5,rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,0>',repP)
