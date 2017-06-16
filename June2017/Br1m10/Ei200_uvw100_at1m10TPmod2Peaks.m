function Ei200_uvw100_at1m10TPmod2Peaks()
%function [D,x0,alpha,result] = Ei200_uvw100_at110TPmodel2Peaks()
% simplified verification script, which allows one to check
% how do sqw cut works

%-------------------------------------------------
% Parameters :
%
root = fileparts(pwd);
data_source= fullfile(root,'sqw','Data','Fe_ei200.sqw');

bragg = [1,-1,0];  % selected bragg
dE = 5;
dK = 0.05;
%
% Cut properties:
%
repPoints1 = [-0.3,-0.06,0,0.28,0.32;
    100,10,0,70,120];
repPoints2= [-0.32,-0.24,0,0.08,0.30;
    120,70,0,10,95];
repPoints3 = [-0.33,-0.07,0,0.08,0.32;
    105,10,0,10,110];

rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)

