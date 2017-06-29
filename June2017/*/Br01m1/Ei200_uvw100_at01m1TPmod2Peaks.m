function Ei200_uvw100_at01m1TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');

bragg = [0,1,-1];
dE = 5;
dK = 0.05;

repPoints1 = [-0.15,-0.04,0,0.1,0.25;
    35,10,0,15,60];
repPoints2= [-0.18,-0.07,0,0.09,0.25;
    40,10,0,10,60];
repPoints3 = [-0.2,-0.07,0,0.08,0.23;
    40,10,0,10,50];
% Cuts
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,0,0>',repP)
