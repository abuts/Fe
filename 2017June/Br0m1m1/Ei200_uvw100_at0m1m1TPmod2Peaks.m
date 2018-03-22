function Ei200_uvw100_at0m1m1TPmod2Peaks()
%function [D,x0,alpha,result] = Ei200_uvw100_at110TPmodel2Peaks()
% simplified verification script, which allows one to check
% how do sqw cut works

%-------------------------------------------------
% Parameters :
%
root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');

bragg = [0,-1,-1];  % selected bragg
dE = 5;
dK = 0.05;
%
% Cut properties:
%
repPoints1 = [-0.32,-0.1,0,0.08,0.34;
    100,15,0,10,120];
repPoints2= [-0.31,-0.1,0,0.07,0.33;
    100,15,0,10,120];
repPoints3 = [-0.3,-0.1,0,0.09,0.33;
    100,15,0,10,120];

rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)

