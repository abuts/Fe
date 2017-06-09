function Ei400_uvw110_at110TPmod2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei401.sqw');
bragg = [1,1,0];
avrg_par=[0,0,1042.5304];

if nargin == 0
    repPoints1= [-0.3375,-0.1625,0,0.1625,0.4625;
        121,25,0,27,193];
    repPoints2 = [-0.3625,-0.0875,0,0.2125,0.4125;
        157,21,0,33,165];
    repPoints3 = [-0.3125,-0.1375,0,0.1625,0.4375;
        141,25,0,25,183];
    repPoints4 = [-0.3625,-0.1625,0,0.1375,0.3875;
        141,19,0,25,179];
    repPoints5 = [-0.3375,-0.1125,0,0.1625,0.4375;
        145,25,0,23,177];
    repPoints6 = [-0.3625,-0.1625,0,0.1375,0.3875;
        143,29,0,21,177];
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    %    5.3907   -4.7067  973.3417
    repPoints1= [    -0.3375   -0.1625         0    0.1625    0.4625;
        117.8489   31.8579    5.3907   30.3282  211.4177];
    %   7.8053  -13.4125  964.9361
    repPoints2 = [    -0.3625   -0.0875         0    0.2125    0.4125;
        139.4660   16.3667    7.8053   48.5281  166.4626];
    %  1.0e+03 *[ -0.0026   -0.0399    1.1034]
    repPoints3 = [ -0.3125   -0.1375         0    0.1625    0.4375;
        117.6157   23.7343   -2.6176   20.0301  191.1104];
    %    3.4226   10.3652  930.9917
    repPoints4 = [  -0.3125   -0.0875         0    0.0875    0.3125;
        91.1006    9.6435    3.4226   11.4575   97.5789];
    % 1.0e+03 *[  -0.0004   -0.0135    1.0941]
    repPoints5=[   -0.3375   -0.1125         0    0.1625    0.4375;
        128.8084   14.9865   -0.3817   26.3134  203.1270];
    % 1.0e+03 *[    0.0016    0.0177    1.0477]
    repPoints6 = [    -0.3625   -0.1625         0    0.1375    0.3875;
        132.8386   26.3758    1.5913   23.8376  165.7819];
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    %rp1.p = avrg_par;
    rp1.fix_x_coordinate = false;
    
end

% #1
rp1.cut_direction=[1,1,0];
rp1.dE=10;
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

do_fits(data_source,bragg,'<1,1,0>',repP)
