function Ei200_uvw110_at1m10TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root,'sqw','Data','Fe_ei200.sqw');

bragg = [1,-1,0];
dE = 5;
dK = 0.05;


refP1= [-0.29,-0.1,0,0.15,0.3;
    110,15,0,15,110];
refP2 = [-0.29,-0.04,0,0.23,0.33;
    85,10,0,75,125];
refP3 = [-0.3,-0.08,0,0.08,0.34;
    100,10,0,10,115];
refP4 = [-0.3,-0.04,0,0.09,0.37;
    100,10,0,10,120];
refP5 = [-0.36,-0.1,0,0.06,0.3;
    120,10,0,10,100];
refP6 = [-0.34,-0.08,0,0.07,0.32;
    120,10,0,10,100];

rp1 = parWithCorrections(refP1,bragg,[1,1,0],dE,dK);
rp2 = parWithCorrections(refP2,bragg,[1,-1,0],dE,dK);
rp3 = parWithCorrections(refP3,bragg,[1,0,1],dE,dK);
rp4 = parWithCorrections(refP4,bragg,[1,0,-1],dE,dK);
rp5 = parWithCorrections(refP5,bragg,[0,1,1],dE,dK);
rp6 = parWithCorrections(refP6,bragg,[0,1,-1],dE,dK);

repP={rp2,rp1,rp3,rp4,rp5,rp6};

do_fits(data_source,bragg,'<1,1,0>',repP)

