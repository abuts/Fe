function Ei400_uvw100_at110auto(varargin)

data_source= fullfile(pwd,'Fe_ei401.sqw');
avrg_par=[0,0,1139.482];
no_chkpnts= 'True';
Imax = 1; % fitting considered wrong if intensity deviates from average by this range

if nargin == 0
    repPoints1= [-0.3375,-0.1625,0,0.1875,0.3875;
        135,31,0,23,187];
    
    repPoints2 = [-0.3375,-0.1625,0,0.1875,0.4375;
        133,31,0,25,189];
    repPoints3 = [-0.3875,-0.1375,0,0.1625,0.3875;
        159,25,0,25,163];

    rp1 = parWithCorrections(repPoints1);
    rp1.fix_x_coordinate = false;
else
    repPoints1=  [  -0.3375   -0.1625         0    0.1875    0.3875;
        132.3383   31.2726    0.7914   41.4428  174.3464];
    repPoints2=[-0.3375   -0.1625         0    0.1875    0.4375;
        130.3234   31.8632    2.2336   41.9916  218.2458];
    
    repPoints3=[-0.3875   -0.1375         0    0.1625    0.3875;
        187.6851   29.8303    3.5519   27.8886  160.6537];
    
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    % ignore reference points and set spin wave parameters directly
    %rp1.p = avrg_par;
    % check it, true sets cut position on the spin wave exactly
    rp1.fix_x_coordinate = true;
end
% Cuts
% #1
rp1.cut_direction=[0,1,0];
rp1.dE = 4;
rp1.dk = 0.1;
% #2
rp2 = parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[1,0,0];
% #3
rp3 = parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[0,0,1];

repP={rp1,rp2,rp3};
n_energy_points=10;
if(nargin>0)
    n_energy_points = numel(varargin{1});
end
run_cuts(data_source,no_chkpnts,repP,[1,1,0],Imax,n_energy_points)

