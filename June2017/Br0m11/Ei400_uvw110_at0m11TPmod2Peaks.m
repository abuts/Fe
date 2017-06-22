function Ei400_uvw110_at0m11TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [0,-1,1];
dE = 10;
dK = 0.05;



repPoints1= [-0.39,-0.11,0,0.14,0.31;
    140,20,0,20,90];
repPoints2 = [-0.23,-0.08,0,0.13,0.34;
    90,20,0,25,140];
repPoints3 = [-0.31,-0.08,0,0.16,0.31;
    120,20,0,20,110];
repPoints4 = [-0.29,-0.11,0,0.19,0.36;
    110,20,0,25,120];
repPoints5 = [-0.34,-0.11,0,0.11,0.29;
    140,20,0,20,85];
repPoints6 = [-0.33,-0.11,0,0.14,0.31;
    130,20,0,20,90];


rp1 = parWithCorrections(repPoints1,bragg,[1,1,0],dE,dK);
rp2 = parWithCorrections(repPoints2,bragg,[1,-1,0],dE,dK);
rp3 = parWithCorrections(repPoints3,bragg,[1,0,1],dE,dK);
rp4 = parWithCorrections(repPoints4,bragg,[1,0,-1],dE,dK);
rp5 = parWithCorrections(repPoints5,bragg,[0,1,1],dE,dK);
rp6 = parWithCorrections(repPoints6,bragg,[0,1,-1],dE,dK);


repP={rp6,rp5,rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,0>',repP)
