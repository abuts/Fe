function Ei400_uvw111_at0m1m1TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [0,-1,-1];
dE = 10;
dK = 0.05;

pefP1= [-0.33,-0.11,0,0.13,0.31;
    125,20,0,25,95];
pefP2 = [-0.34,-0.09,0,0.11,0.26;
    135,15,0,15,90];
pefP3 = [-0.29,-0.07,0,0.14,0.34;
    95,15,0,25,130];
pefP4 = [-0.24,-0.07,0,0.11,0.34;
    90,20,0,20,135];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP ={rp4,rp3,rp1,rp2};

do_fits(data_source,bragg,'<1,1,1>',repP)
