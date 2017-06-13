function Ei200_uvw100_at1m10TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

avrg_par=[0,0,949.35];
bragg = [1,-1,0];
dE = 5;
dK = 0.05;

repPoints1 = [-0.2625,-0.0875,0,0.2875,0.3375;
    95,15,0,65,120];
repPoints2= [-0.3375,-0.2625,0,0.0875,0.3125;
    125,70,0,15,100];
repPoints3 = [-0.3375,-0.1125,0,0.0875,0.3125;
    110,15,0,15,110];
% Cuts
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)
