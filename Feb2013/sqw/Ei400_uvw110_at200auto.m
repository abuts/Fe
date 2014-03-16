function Ei400_uvw110_at200auto(varargin)

data_source= fullfile(pwd,'Fe_ei401.sqw');

avrg_par=[0,0,928.7471];
no_chkpnts= 'True';
Imax = 1;

if nargin == 0
    repPoints1= [-0.3875,-0.1375,0,0.1875,0.5125;
        180,40,0,30,230];
    repPoints2 = [-0.3875,-0.1375,0,0.3875,0.4875;
        190,40,0,130,240];
    repPoints3 = [-0.4125,-0.1875,0,0.2375,0.4875;
        190,30,0,40,230];
    repPoints4 = [-0.3875,-0.1875,0,0.1875,0.4875;
        180,30,0,20,240];
    repPoints5 = [-0.4875,-0.1625,0,0.1625,0.4625;
        210,30,0,30,210];
    repPoints6 = [-0.4875,-0.1625,0,0.1625,0.4625;
        210,30,0,20,215];
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    % 17.3292  -14.8999  895.8357
    repPoints1= [    -0.3875   -0.1375         0    0.1875    0.5125;
        157.6182   36.3148   17.3292   46.0297  244.9899];
    % 7.4146  -64.5383  837.7572
    repPoints2 = [  -0.3875   -0.1375         0    0.3875    0.4875;
        158.2177   32.1275    7.4146  108.2005  175.0504];
    %13.4151  -36.7506  926.5829
    repPoints3 = [ -0.4125   -0.1875         0    0.2375    0.4875;
        186.2386   52.8810   13.4151   56.9519  215.7074];
    % 8.1174  -26.1129  961.4452
    repPoints4 = [  -0.3875   -0.1875         0    0.1875    0.4875;
        162.6031   46.8144    8.1174   37.0220  223.8808];
    % 9.2552    4.9743  978.8777
    repPoints5=[    -0.4875   -0.1625         0    0.1625    0.4625;
        239.4666   34.2954    9.2552   35.9120  220.9439];
    %10.4732   10.0938  971.9839
    repPoints6 = [    -0.4875   -0.1625         0    0.1625   0.4625;
        236.5505   34.4994   10.4732   37.7799  223.0550];
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    %rp1.p = avrg_par;
    rp1.fix_x_coordinate = false;
    
end

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
run_cuts(data_source,no_chkpnts,repP,[2,0,0],Imax,n_energy_points,'Ei400','<1,1,0>')

