function Ei400_uvw111_at101TpMod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,0,1];
dE = 10;
dK = 0.05;

pefP1= [-0.31,-0.14,0,0.11,0.31;
    100,20,0,15,125];
pefP2 = [-0.26,-0.14,0,0.11,0.36;
    90,25,0,20,140];
pefP3 = [-0.26,-0.11,0,0.16,0.36;
    90,20,0,25,140];
pefP4 = [-0.29,-0.09,0,0.16,0.36;
    100,20,0,25,130];


rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP ={rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,1>',repP)
