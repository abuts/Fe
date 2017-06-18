function Ei400_uvw110_at101TpMod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,0,1];
dE = 10;
dK = 0.05;



repPoints1= [-0.26,-0.11,0,0.11,0.36;
    90,25,0,15,140];
repPoints2 = [-0.26,-0.11,0,0.16,0.34;
    90,20,0,30,140];
repPoints3 = [-0.31,-0.11,0,0.14,0.31;
    90,20,0,20,130];
repPoints4 = [-0.31,-0.11,0,0.11,0.39;
    105,20,0,15,140];
repPoints5 = [-0.31,-0.16,0,0.06,0.31;
    120,25,0,20,110];
repPoints6 = [-0.29,-0.11,0,0.11,0.34;
    110,25,0,15,120];


rp1 = parWithCorrections(repPoints1,bragg,[1,1,0],dE,dK);
rp2 = parWithCorrections(repPoints2,bragg,[1,-1,0],dE,dK);
rp3 = parWithCorrections(repPoints3,bragg,[1,0,1],dE,dK);
rp4 = parWithCorrections(repPoints4,bragg,[1,0,-1],dE,dK);
rp5 = parWithCorrections(repPoints5,bragg,[0,1,1],dE,dK);
rp6 = parWithCorrections(repPoints6,bragg,[0,1,-1],dE,dK);


repP={rp6,rp5,rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,0>',repP)
