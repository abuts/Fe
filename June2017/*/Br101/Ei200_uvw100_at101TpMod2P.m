function Ei200_uvw100_at101TpMod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');

bragg = [1,0,1];
dE = 5;
dK = 0.05;

repPoints1 = [-0.26,-0.09,0,0.09,0.29;
    50,10,0,10,90];
repPoints2= [-0.26,-0.09,0,0.11,0.26;
    70,10,0,10,75];
repPoints3 = [-0.26,-0.08,0,0.11,0.24;
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
