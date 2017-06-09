function Ei200_uvw100_at110TPmodel2Peaks()
%function [D,x0,alpha,result] = Ei200_uvw100_at110TPmodel2Peaks()
% simplified verification script, which allows one to check
% how do sqw cut works

%-------------------------------------------------
% Parameters :
%
data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [1,1,0];  % selected bragg
%
% Cut properties:
%
repPoints1 = [-0.2625,-0.1125,0,0.1375,0.3625;
    95,19,0,19,123];

repPoints2= [-0.2875,-0.0875,0,0.1375,0.3375;
    95,15,0,19,121];
repPoints3 = [-0.3125,-0.1125,0,0.1375,0.25;
    109,21,0,19,84];

rp1 = parWithCorrections(repPoints1);
rp1.cut_direction=[1,0,0];
rp1.dE = 5;
rp1.dk = 0.05;
% #2
rp2 = parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[0,1,0];
% #3
rp3 = parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[0,0,1];

repP={rp1,rp2,rp3};

do_fits(data_source,bragg,'<1,0,0>',repP)

