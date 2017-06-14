function Ei200_uvw111_at110TPmod2Peaks(varargin)


root = fileparts(pwd);
data_source= fullfile(root,'sqw','Data','Fe_ei200.sqw');


bragg = [1,1,0];
BraggName = parWithCorrections.getTextFromVector(bragg);
dE =5;
dK =0.05;


pefP1 = [-0.325,-0.075,0,0.125,0.425;
    140,15,0,15,155];
pefP2 = [-0.3125,-0.0875,0,0.1375,0.3875;
    130,15,0,15,155];
pefP3 = [-0.3375,-0.1125,0,0.1375,0.4125;
    130,15,0,15,150];
pefP4 = [-0.3635,-0.1375,0,0.1125,0.3375;
    15,15,0,15,130];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP={rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
