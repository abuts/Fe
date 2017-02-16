function Ei800_uvwAll(varargin)

data_source= fullfile(pwd,'Data','sqw','Fe_ei800allSym.sqw');
bragg = [1,1,0];

if nargin == 0
    repPoints1= [-0.3875,-0.1875,0,0.1875,0.4125;
        160,30,0,30,160];
    repPoints2 = [-0.3375,-0.1875,0,0.2375,0.4625;
        110,30,0,40,190];
    repPoints3 = [-0.3625,-0.1625,0,0.1875,0.4125;
        140,30,0,30,190];
    repPoints4 = [-0.3375,-0.1375,0,0.1875,0.4125;
        140,20,0,30,180];
    repPoints5 = [-0.4375,-0.2125,0,0.1375,0.3375;
        180,30,0,30,140];
    repPoints6 = [-0.3875,-0.1625,0,0.1825,0.3625;
        180,30,0,30,140];
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    %1.0e+03 *[   -0.0117   -0.0038    1.1818]
    repPoints1= [-0.3875   -0.1875         0    0.1875    0.4125;
        167.2300   30.5557  -11.7097   29.1218  187.8074];
    %1.0e+03 *[   -0.0068   -0.0323    1.1292]
    repPoints2 = [-0.3375   -0.1875         0    0.2375    0.4625;
        132.6691   38.9071   -6.8385   49.1955  219.7875];
    % 1.0e+03 *[    0.0003    0.0129    1.0594]
    repPoints3 = [ -0.3625   -0.1625         0    0.1875    0.4125;
        134.8687   26.2039    0.3184   39.9732  185.8838];
    %    3.4226   10.3652  930.9917
    repPoints4 = [  -0.3125   -0.0875         0    0.0875    0.3125;
        91.1006    9.6435    3.4226   11.4575   97.5789];
    %1.0e+03 *[    0.0066    0.0330    1.0269]
    repPoints5=[  -0.4375   -0.2125         0    0.1375    0.3375;
        188.7405   45.9838    6.6260   30.5780  134.7319];
    %1.0e+03 *[   -0.0120    0.0015    1.1848]
    repPoints6 = [ -0.3875   -0.1625         0    0.1825    0.3625;
        165.3115   19.0218  -12.0269   27.7007  144.1918];
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    %rp1.p = avrg_par;
    rp1.fix_x_coordinate = false;
    
end

% #1
rp1.cut_direction=[1,1,0];
rp1.dE=10;
rp1.dk = 0.1;
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
[D,x0,alpha,e_sw,Icr,dIcr,all_plots]=calc_sw_intencity(data_source,bragg,cut_direction,cut_p,dE,dK);

%run_cuts(data_source,no_chkpnts,repP,[2,0,0],Imax,n_energy_points,'Ei800','<1,1,0>')

