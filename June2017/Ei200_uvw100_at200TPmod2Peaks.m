function Ei200_uvw100_at200TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');
avrg_par=[0,0,949.35];
if nargin == 0
    repPoints1 = [-0.275,-0.075,0,0.175,0.375;
        123,15,0,19,153];
    
    repPoints2=[-0.3375,-0.1875,0,0.1875,0.3375;
        123,31,0,27,137];
    repPoints3=[-0.31,-0.12,0,0.12,0.35;
        140,20,0,20,140];
    
    
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    repPoints1= [ -0.2750   -0.0750         0    0.1750    0.3750;
                   91.7833   11.7817    3.9750   32.8374  146.5281];
    repPoints2= [ -0.3375   -0.1875         0    0.1875    0.3375;
                  126.1526   38.0691   -0.9930   38.8807  127.6135];

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
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[0,1,0];

rp3 = parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[0,0,1];


repP={rp1,rp2,rp3};

do_fits(data_source,[2,0,0],'<1,0,0>',repP)



