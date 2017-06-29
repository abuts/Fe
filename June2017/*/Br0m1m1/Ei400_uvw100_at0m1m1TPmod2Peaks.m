function Ei400_uvw100_at0m1m1TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [0,-1,-1];
dE = 10;
dK = 0.05;


repPoints1= [-0.26,-0.09,0,0.23,0.31;
    110,15,0,30,120];

repPoints2 = [-0.36,-0.11,0,0.11,0.26;
    140,20,0,15,80];
repPoints3 = [-0.36,-0.13,0,0.09,0.31;
    120,20,0,15,105];


rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)

