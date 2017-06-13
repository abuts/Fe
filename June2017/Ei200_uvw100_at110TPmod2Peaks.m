function Ei200_uvw100_at110TPmod2Peaks()
%function [D,x0,alpha,result] = Ei200_uvw100_at110TPmodel2Peaks()
% simplified verification script, which allows one to check
% how do sqw cut works

%-------------------------------------------------
% Parameters :
%
data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [1,1,0];  % selected bragg
dE = 5;
dK = 0.05;
%
% Cut properties:
%
repPoints1 = [-0.2625,-0.1125,0,0.1375,0.3625;
    95,20,0,20,125];

repPoints2= [-0.2875,-0.0875,0,0.1375,0.3375;
    95,15,0,15,120];
repPoints3 = [-0.3125,-0.1125,0,0.1375,0.25;
    110,20,0,20,85];

rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)

