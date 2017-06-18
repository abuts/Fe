function Ei400_uvw110_at110TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');

bragg = [1,1,0];
dE = 10;
dK = 0.05;



  repPoints1= [-0.3375,-0.1625,0,0.1625,0.4625;
        120,25,0,30,195];
    repPoints2 = [-0.3625,-0.0875,0,0.2125,0.4125;
        160,20,0,35,165];
    repPoints3 = [-0.3125,-0.1375,0,0.1625,0.4375;
        140,25,0,25,185];
    repPoints4 = [-0.3625,-0.1625,0,0.1375,0.3875;
        140,20,0,25,180];
    repPoints5 = [-0.3375,-0.1125,0,0.1625,0.4375;
        145,25,0,25,180];
    repPoints6 = [-0.3625,-0.1625,0,0.1375,0.3875;
        145,30,0,20,180];


% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,1,0],dE,dK);

% #2
rp2 = parWithCorrections(repPoints2,bragg,[1,-1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[1,0,1],dE,dK);

% #4
rp4 = parWithCorrections(repPoints4,bragg,[1,0,-1],dE,dK);

% #5
rp5 = parWithCorrections(repPoints5,bragg,[0,1,1],dE,dK);

% #6
rp6 = parWithCorrections(repPoints6,bragg,[0,1,-1],dE,dK);


repP={rp6,rp5,rp4,rp3,rp2,rp1};

do_fits(data_source,bragg,'<1,1,0>',repP)
