function Ei400_uvw111_at110TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei401.sqw');
bragg = [1,1,0];

repPoints1= [-0.36,-0.16,0,0.13,0.41;
    130,25,0,20,190];
repPoints2 = [-0.38,-0.12,0,0.1438,0.4063;
    160,20,0,24,165];
repPoints3 = [-0.41,-0.14,0,0.1,0.4;
    165,25,0,20,160];
repPoints4 = [-0.42,-0.14,0,0.16,0.42;
    165,25,0,25,165];

rp1=parWithCorrections(repPoints1);
rp1.fix_x_coordinate=false;
% #1
rp1.cut_direction=[1,1,1];
rp1.dE=10;
rp1.dk = 0.05;
% #2
rp2 = parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[1,-1,1];
% #3
rp3 = parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[-1,1,1];

% #4
rp4 = parWithCorrections(rp1);
rp4.ref_par_X = repPoints4;
rp4.cut_direction=[1,-1,-1];

repP = {rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
