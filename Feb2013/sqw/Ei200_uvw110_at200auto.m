function Ei200_uvw110_at200auto(varargin)

data_source= fullfile(pwd,'Data','Fe_ei200.sqw');


avrg_par=[0,0,1007.2656];
no_chkpnts= 'True';
Imax = 1;

if nargin == 0
    repPoints1= [-0.3375,-0.1125,0,0.1375,0.3875;
        130,20,0,15,145];
    repPoints2 = [-0.3375,-0.1375,0,0.1625,0.3875;
        130,20,0,20,150];
    repPoints3 = [-0.3125,-0.0875,0,0.1375,0.3375;
        120,10,0,15,110];
    repPoints4 = [-0.3375,-0.1125,0,0.1875,0.3375;
        120,20,0,20,150];
    repPoints5 = [-0.3125,-0.1375,0,0.1125,0.3375;
        140,20,0,20,140];
    repPoints6 = [-0.3625,-0.1375,0,0.1375,0.3375;
        140,20,0,20,140];
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    % 4.3296  -20.7937  989.6903
    repPoints1= [ -0.3375   -0.1125         0    0.1375    0.3875;
        124.0794   19.1947    4.3296   20.1818  144.8803];
    
    %  1.0e+03 *[   -0.0012   -0.0202    1.0511]
    repPoints2 = [    -0.3375   -0.1375         0    0.1625    0.3875;
        125.3426   21.4451   -1.2061   23.2662  148.7950];
    %   6.1357  -33.8644  919.4129
    repPoints3 = [ -0.3125   -0.0875         0    0.1375    0.3375;
        106.5047   16.1381    6.1357   18.8620   99.4333];
    %      6.2255   -6.0271  952.1196
    repPoints4 = [  -0.3375   -0.1125         0    0.1875    0.3375;
        116.7120   18.9538    6.2255   38.5683  112.6437];
    %1.0e+03 *[    0.0019   -0.0041    1.0452]
    repPoints5=[  -0.3125   -0.1375         0    0.1125    0.3375;
        105.2830   22.2591    1.9385   14.7099  119.6252];
    %1.0e+03 *[   -0.0009    0.0131    1.0860]
    repPoints6 = [ -0.3625   -0.1375         0    0.1375    0.3375;
        137.0389   17.8025   -0.9329   21.3968  127.1826];
    
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    %rp1.p = avrg_par;
    rp1.fix_x_coordinate = false;
    
end

no_chkpnts= 'True';% Cuts
% #1
rp1.cut_direction=[1,1,0];
rp1.dE=7.5;
rp1.dk = 0.075;
% #2
rp2 = parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[1,-1,0];
% #3
rp3 = parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[1,0,1];
% #4
rp4 = parWithCorrections(rp1);
rp4.ref_par_X = repPoints4;
rp4.cut_direction=[1,0,-1];
% #5
rp5 = parWithCorrections(rp1);
rp5.ref_par_X = repPoints5;
rp5.cut_direction=[0,1,1];
% #6
rp6 = parWithCorrections(rp1);
rp6.ref_par_X = repPoints6;
rp6.cut_direction=[0,1,-1];

repP={rp1,rp2,rp3,rp4,rp5,rp6};
n_energy_points=10;
if(nargin>0)
    n_energy_points = numel(varargin{1});
end
run_cuts(data_source,no_chkpnts,repP,[2,0,0],Imax,n_energy_points,'Ei200','<1,1,0>')

