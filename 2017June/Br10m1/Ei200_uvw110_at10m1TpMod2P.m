function repP=Ei200_uvw110_at10m1TpMod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');

bragg = [1,0,-1];
dE = 5;
dK = 0.05;


repPoints1= [-0.23,-0.09,0,0.09,0.29;
    60,15,0,15,85];
repPoints2 = [-0.24,-0.11,0,0.11,0.29;
    60,15,0,15,85];
repPoints3 = [-0.26,-0.09,0,0.11,0.26;
    60,15,0,15,65];
repPoints4 = [-0.21,-0.09,0,0.09,0.31;
    50,15,0,15,85];
repPoints5 = [-0.26,-0.09,0,0.11,0.26;
    80,15,0,15,75];
repPoints6 = [-0.26,-0.09,0,0.11,0.26;
    70,15,0,15,80];
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,1,0],dE,dK);
rp2 = parWithCorrections(repPoints2,bragg,[1,-1,0],dE,dK);
rp3 = parWithCorrections(repPoints3,bragg,[1,0,1],dE,dK);
rp4 = parWithCorrections(repPoints4,bragg,[1,0,-1],dE,dK);
rp5 = parWithCorrections(repPoints5,bragg,[0,1,1],dE,dK);
rp6 = parWithCorrections(repPoints6,bragg,[0,1,-1],dE,dK);

repP={rp1,rp2,rp3,rp4,rp5,rp6};
if nargin == 0
    do_fits(data_source,bragg,'<1,1,0>',repP)
end

