function Ei400_uvw110_at101Tpmod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,0,1];
dE = 10;
dK = 0.05;



repPoints1= [-0.34,-0.08,0,0.14,0.31;
    140,15,0,25,90];
repPoints2 = [-0.26,-0.04,0,0.14,0.36;
    90,20,0,25,140];
repPoints3 = [-0.34,-0.11,0,0.14,0.29;
    115,15,0,20,110];
repPoints4 = [-0.31,-0.11,0,0.16,0.33;
    105,15,0,25,120];
repPoints5 = [-0.36,-0.13,0,0.14,0.26;
    145,20,0,20,85];
repPoints6 = [-0.31,-0.11,0,0.11,0.31;
    130,15,0,15,90];


rp1 = parWithCorrections(repPoints1,bragg,[1,1,0],dE,dK);
rp2 = parWithCorrections(repPoints2,bragg,[1,-1,0],dE,dK);
rp3 = parWithCorrections(repPoints3,bragg,[1,0,1],dE,dK);
rp4 = parWithCorrections(repPoints4,bragg,[1,0,-1],dE,dK);
rp5 = parWithCorrections(repPoints5,bragg,[0,1,1],dE,dK);
rp6 = parWithCorrections(repPoints6,bragg,[0,1,-1],dE,dK);


repP={rp1,rp2,rp3,rp4,rp5,rp6};

do_fits(data_source,bragg,'<1,1,0>',repP)
