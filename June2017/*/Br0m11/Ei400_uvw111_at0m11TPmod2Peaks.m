function Ei400_uvw111_at0m11TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [0,-1,1];
dE = 10;
dK = 0.05;

pefP1= [-0.31,-0.11,0,0.14,0.31;
    130,20,0,20,90];
pefP2 = [-0.36,-0.08,0,0.13,0.31;
    130,15,0,20,95];
pefP3 = [-0.26,-0.06,0,0.16,0.36;
    90,20,0,25,135];
pefP4 = [-0.28,-0.09,0,0.14,0.34;
    95,20,0,20,130];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP ={rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
