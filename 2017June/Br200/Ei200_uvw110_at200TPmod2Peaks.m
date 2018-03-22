function repP= Ei200_uvw110_at200TPmod2Peaks(varargin)

root = fileparts(pwd);
data_source= fullfile(root,'sqw','Data','Fe_ei200.sqw');

bragg = [2,0,0];
dE = 5;
dK = 0.05;



repPoints1= [-0.34,-0.11,0,0.08,0.41;
    125,15,0,10,152];
repPoints2 = [-0.34,-0.11,0,0.11,0.38;
    130,15,0,10,150];
repPoints3 = [-0.33,-0.06,0,0.08,0.39;
    125,10,0,10,151];
repPoints4 = [-0.34,-0.09,0,0.13,0.39;
    125,10,0,10,150];
repPoints5 = [-0.33,-0.11,0,0.11,0.34;
    140,15,0,10,140];
repPoints6 = [-0.34,-0.1,0,0.08,0.34;
    140,10,0,10,140];
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

if nargin == 0
    do_fits(data_source,bragg,'<1,1,0>',repP)
end

