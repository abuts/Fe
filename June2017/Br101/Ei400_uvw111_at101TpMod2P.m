function Ei400_uvw111_at101Tpmod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,0,1];
dE = 10;
dK = 0.05;

pefP1= [-0.36,-0.14,0,0.11,0.31;
    140,20,0,20,90];
pefP2 = [-0.34,-0.09,0,0.11,0.24;
    130,15,0,20,100];
pefP3 = [-0.26,-0.06,0,0.16,0.38;
    90,15,0,25,140];
pefP4 = [-0.29,-0.07,0,0.11,0.36;
    100,20,0,20,130];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP ={rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
