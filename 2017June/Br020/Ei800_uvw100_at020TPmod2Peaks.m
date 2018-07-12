function Ei800_uvw100_at020TPmod2Peaks(varargin)

root_folder = pwd;
this_fldr = fileparts(root_folder);
data_source= fullfile(this_fldr,'sqw','Data','Fe_ei787.sqw');
bragg = [0,2,0];


dE = 5;
dK = 0.1;


repPoints1=  [ -0.575   -0.175      0   0.175    0.525;
               275        85        0      85      310];
repPoints2=[-0.475   -0.125         0    0.175    0.525;
             240        35          0       35      290];
repPoints3=[-0.575   -0.125         0    0.175    0.525;
              325       35          0     35      310];


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



