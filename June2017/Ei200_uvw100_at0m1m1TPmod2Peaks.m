function Ei200_uvw100_at0m1m1TPmod2Peaks()
%function [D,x0,alpha,result] = Ei200_uvw100_at110TPmodel2Peaks()
% simplified verification script, which allows one to check
% how do sqw cut works

%-------------------------------------------------
% Parameters :
%
data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [0,-1,-1];  % selected bragg
dE = 5;
dK = 0.05;
%
% Cut properties:
%
repPoints1 = [-0.25,-0.11,0,0.11,0.26;
    70,15,0,15,80];
repPoints2= [-0.28,-0.095,0,0.095,0.2;
    90,15,0,15,55];
repPoints3 = [-0.25,-0.125,0,0.095,0.25;
    60,15,0,15,75];

rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[1,0,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[1,0,0],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)

