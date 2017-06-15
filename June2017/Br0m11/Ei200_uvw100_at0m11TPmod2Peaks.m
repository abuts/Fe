function Ei200_uvw100_at0m11TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');

bragg = [0,-1,1];
dE = 5;
dK = 0.05;

repPoints1 = [-0.24,-0.09,0,0.1,0.25;
    70,10,0,10,75];
repPoints2= [-0.28,-0.09,0,0.09,0.24;
    90,10,0,10,55];
repPoints3 = [-0.28,-0.09,0,0.9,0.23;
    75,10,0,10,50];
% Cuts
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)
