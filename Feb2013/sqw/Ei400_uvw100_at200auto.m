function Ei400_uvw100_at200auto(varargin)

data_source= fullfile(pwd,'Fe_ei401.sqw');
avrg_par=[0,0,1065.0871];
no_chkpnts= 'True';
Imax = 1; % fitting considered wrong if intensity deviates from average by this range
if nargin == 0
    repPoints1= [-0.4375,-0.1875,0,0.1875,0.4625;
        215,53,0,50,215];
    repPoints2 = [-0.3375,-0.1375,0,0.2375,0.5125
        175,31,0,50,250];
    repPoints3 = [-0.3875,-0.1375,0,0.1625,0.3375;
        160,40,0,25,130];
    
    rp1 = parWithCorrections(repPoints1);
    rp1.fix_x_coordinate = false;
else
    repPoints1= [ -0.4375   -0.1875         0    0.1875    0.4625;
        212.0848   46.1861    9.9312   49.2498  243.6211];
    
    repPoints2= [ -0.3375   -0.1375         0    0.2375    0.5125;
        137.4802   36.3682   13.5698   63.8479  263.9431];
    
    repPoints3= [ -0.3875   -0.1375         0    0.1625    0.3375;
        179.3615   29.9486    7.1141   34.4237  129.6155];
    
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    % ignore reference points and set spin wave parameters directly
    %rp1.p = avrg_par;
    % check it, true sets cut position on the spin wave exactly
    rp1.fix_x_coordinate = true;
end
rp1.Esw_threshold=40;
rp1.cut_direction=[0,1,0];
rp1.dE =5;
rp1.dk =0.1;

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

run_cuts(data_source,no_chkpnts,repP,[2,0,0],Imax,n_energy_points,'Ei400','<1,0,0>')

