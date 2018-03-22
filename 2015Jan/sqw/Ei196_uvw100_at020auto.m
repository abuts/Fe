function Ei196_uvw100_at020auto(varargin)

data_source= fullfile(pwd,'Fe_ei196.sqw');
avrg_par=[0,0,949.35];
no_chkpnts= 'True';
Imax = 1;
if nargin == 0
    repPoints1 = [-0.325,-0.125,0,0.225,0.375;
        142.5,32.5,0,57.5,142.5];
    
    repPoints2=[-0.275,-0.125,0,0.225,0.375;
        117,32,0,27,152];

    
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    repPoints1= [ -0.2750   -0.1250         0    0.1750    0.3750;
                   91.7833   32.5    3.9750   32.8374  146.5281];
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
rp1.dk = 0.1;
% #2
rp2 = parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[0,1,0];


repP={rp1,rp2};
n_energy_points=10;
if(nargin>0)
    n_energy_points = numel(varargin{1});
end
run_cuts(data_source,no_chkpnts,repP,[0,2,0],Imax,n_energy_points,'Ei200','<1,0,0>')


