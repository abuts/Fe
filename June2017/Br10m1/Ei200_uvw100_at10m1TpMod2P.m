function repP=Ei200_uvw100_at10m1TpMod2P(varargin)

root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei200.sqw');

bragg = [1,0,-1];
dE = 5;
dK = 0.05;

repPoints1 = [-0.23,-0.09,0,0.1,0.31;
    50,15,0,15,90];
repPoints2= [-0.26,-0.11,0,0.11,0.28;
    75,20,0,15,80];
repPoints3 = [-0.23,-0.11,0,0.11,0.26;
    65,15,0,10,80];
% Cuts
% #1
rp1 = parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK);
% #2
rp2 = parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK);
% #3
rp3 = parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK);

repP={rp3,rp2,rp1};
if nargin == 0
    do_fits(data_source,bragg,'<1,0,0>',repP)
end
