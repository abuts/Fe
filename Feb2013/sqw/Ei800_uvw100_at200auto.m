function Ei800_uvw100_at200auto(varargin)

data_source= fullfile(pwd,'Fe_ei787.sqw');
avrg_par=[0,0,994.4436];

no_chkpnts='True';
pause on

Imax = 0.2;
if nargin == 0
    repPoints1=[-0.425,-0.225,0,0.225,0.575;
                         225,65,0,75.5,385];
    
    repPoints2 =[-0.525,-0.225,0,0.325,0.525;
                  315,65.,0,   105.,   325];
    repPoints3 = [-0.525,-0.225,0,0.225,0.475;
                   315, 75,0,    65,315];
    
    rp1 = parWithCorrections(repPoints1);
    rp1.fix_x_coordinate = false;
else
    repPoints1=  [ -0.4250   -0.2250         0    0.2250    0.5750;
                    199.7411   76.5301   27.2401   72.5267  330.9581];
    repPoints2=  [-0.5250   -0.2250         0    0.3250    0.5250;
                   300.1772   56.2273   -2.7123   99.8275  273.1715];
    
    repPoints3=  [-0.5250   -0.2250         0    0.2250    0.4750;
                  297.4735   77.3242   30.2561   84.3682  263.1611];
    
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    % ignore reference points and set spin wave parameters directly
    %rp1.p = avrg_par;
    % check it, true sets cut position on the spin wave exactly
    rp1.fix_x_coordinate = true;
end
rp1.cut_direction=[1,0,0];
rp1.dE = 20;
rp1.dk = 0.1;
% #2
rp2 = parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[0,1,0];
% #3
rp3 = parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[0,0,1];
repP={rp1,rp2,rp3};
n_energy_points=10;
if(nargin>0)
    n_energy_points = numel(varargin{1});
end

run_cuts(data_source,no_chkpnts,repP,[2,0,0],Imax,n_energy_points,'Ei800','<1,0,0>')
