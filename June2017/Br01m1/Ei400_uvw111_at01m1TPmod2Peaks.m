function Ei400_uvw111_at01m1TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [0,1,-1];
dE = 10;
dK = 0.05;

pefP1= [-0.23,-0.04,0,0.13,0.31;
    50,20,0,20,105];
pefP2 = [-0.24,-0.09,0,0.13,0.31;
    55,15,0,20,100];
pefP3 = [-0.26,-0.09,0,0.1,0.26;
    80,15,0,20,75];
pefP4 = [-0.26,-0.07,0,0.14,0.30;
    70,15,0,20,85];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP = {rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
