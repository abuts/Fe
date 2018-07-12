function Ei800_uvw100_at1m10TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei787.sqw');
bragg = [1,-1,0];


dE = 5;
dK = 0.1;


repPoints1=  [  -0.3375   -0.1625         0    0.1875    0.3875;
    132.3383   31.2726    0.7914   41.4428  174.3464];
repPoints2=[-0.3375   -0.1625         0    0.1875    0.4375;
    130.3234   31.8632    2.2336   41.9916  218.2458];

repPoints3=[-0.3875   -0.1375         0    0.1625    0.3875;
    187.6851   29.8303    3.5519   27.8886  160.6537];


% Cuts
% #1

% Cuts
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,0,0>',repP)



