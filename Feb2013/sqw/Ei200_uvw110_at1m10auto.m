function Ei200_uvw110_at1m10auto(varargin)

data_source= fullfile(pwd,'Fe_ei200.sqw');

avrg_par=[0,0,949.9912];
no_chkpnts= 'True';
Imax = 1;

if nargin == 0
    repPoints1= [-0.3125,-0.1125,0,0.1125,0.3125;
        110,10,0,10,110];
    repPoints2 = [-0.2875,-0.0875,0,0.3125,0.3375;
        90,10,0,80,110];
    repPoints3 = [-0.2875,-0.0875,0,0.1125,0.3375;
        100,10,0,15,120];
    repPoints4 = [-0.3125,-0.0875,0,0.1375,0.3375;
        100,10,0,15,115];
    repPoints5 = [-0.3675,-0.1375,0,0.0825,0.2875;
        115,10,0,10,100];
    repPoints6 = [-0.3375,-0.1375,0,0.0875,0.3125;
        115,20,0,10,100];
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    % 1.0e+03 *[  -0.0011    0.0036    1.0044]
    repPoints1= [  -0.3125   -0.1125         0    0.1125    0.3125;
        95.8669   11.2178   -1.0855   12.0358   98.1394];
    %2.5973   11.8662  940.3569
    repPoints2 = [ -0.2875   -0.0875         0    0.1125    0.3375;
        76.9121    8.7586    2.5973   15.8336  113.7146];
    %1.1059  -29.1893  985.4782
    repPoints3 = [ -0.3125   -0.0875         0    0.1375    0.3375;
        106.4657   11.2050    1.1059   15.7241  103.5067];
    %    3.4226   10.3652  930.9917
    repPoints4 = [  -0.3125   -0.0875         0    0.0875    0.3125;
        91.1006    9.6435    3.4226   11.4575   97.5789];
    %3.3946   29.1734  936.9892
    repPoints5=[ -0.3675   -0.1375         0    0.0825    0.2875;
        119.2196   17.0982    3.3946   12.1788   89.2300];
    %5.0447   -8.0187  921.4229
    repPoints6 = [ -0.3375   -0.1375         0    0.0875    0.3125;
        112.7068   23.5679    5.0447   11.3977   92.5215];
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    %rp1.p = avrg_par;
    rp1.fix_x_coordinate = false;
    
end

% #1
rp1.cut_direction=[1,1,0];
rp1.dE=5;
rp1.dk = 0.05;
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
run_cuts(data_source,no_chkpnts,repP,[1,-1,0],Imax,n_energy_points,'Ei200','<1,1,0>')

