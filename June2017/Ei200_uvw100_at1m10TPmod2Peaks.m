function Ei200_uvw100_at1m10TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

avrg_par=[0,0,949.35];

if nargin == 0
    repPoints1 = [-0.2625,-0.0875,0,0.2875,0.3375;
        95,17,0,67,121];   
    repPoints2= [-0.3375,-0.2625,0,0.0875,0.3125;
        123,73,0,13,97];
    repPoints3 = [-0.3375,-0.1125,0,0.0875,0.3125;
        109,13,0,13,109];
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    repPoints1 = [   -0.2625 ,  -0.1125,         0    ,0.1375 ,   0.3580;
        76.2500,   17.1092,    2.0244,   17.6590,  121.0000];
    
    repPoints2= [ -0.2875 ,  -0.0875 ,        0  ,  0.1375 ,   0.3375;
        81.7839 ,  13.0408  ,  6.1338  , 23.7725,  111.5941];
    repPoints3 = [ -0.3125 ,  -0.1125  ,       0,    0.1375,    0.2500;
        105.3054, 19.4796, 4.1003, 17.4702, 54.7273];
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    %rp1.p = avrg_par;
    rp1.fix_x_coordinate = false;    
    
end
% Cuts
% #1
rp1.cut_direction=[1,0,0];
rp1.dE = 5;
rp1.dk = 0.05;
% #2
rp2 = parWithCorrections(rp1);
rp2 = rp2.set_refpar(repPoints2);
rp2.cut_direction=[0,1,0];
% #3
rp3 = parWithCorrections(rp1);
rp3 = rp3.set_refpar(repPoints3);
rp3.cut_direction=[0,0,1];

repP={rp1,rp2,rp3};

do_fits(data_source,[1,-1,0],'<1,0,0>',repP)
