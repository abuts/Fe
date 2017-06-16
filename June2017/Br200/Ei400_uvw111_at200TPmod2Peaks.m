function Ei400_uvw111_at200TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [2,0,0];
dE = 10;
dK = 0.1;

pefP1= [-0.43,-0.125,0,0.125,0.48;
    205,30,0,20,245];
pefP2 = [-0.38,-0.125,0,0.125,0.52;
    200,30,0,25,240];
pefP3 = [-0.38,-0.14,0,0.18,0.48;
    205,25,0,30,250];
pefP4 = [-0.43,-0.125,0,0.18,0.48;
    205,20,0,30,245];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP = {rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
