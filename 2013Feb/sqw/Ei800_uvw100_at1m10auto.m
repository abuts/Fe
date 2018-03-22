function Ei800_uvw100_at1m10auto(varargin)

data_source= fullfile(pwd,'Data','Fe_ei787.sqw');
avrg_par=[0,0,1139.482];


no_chkpnts='True';
pause on

Imax = 0.2;

if nargin == 0
    repPoints1=[-0.275,-0.225,0,0.275,0.425;
        117,42,0,60,225];
    
    repPoints2 = [-0.325,-0.225,0,0.275,0.325;
                   105,   55,   0, 65,  172.5];
    repPoints3 = [-0.375,-0.225,0,0.225,0.325;
                    165,   45,  0,   55, 165];
    
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
rp1.cut_direction=[1,0,0];
rp1.dE = 5;
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
run_cuts(data_source,no_chkpnts,repP,[1,-1,0],Imax,n_energy_points,'Ei800','<1,0,0>')

