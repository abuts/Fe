function Ei200_uvw100_at1m10auto(varargin)

data_source= fullfile(pwd,'Fe_ei200.sqw');

avrg_par=[0,0,949.35];
no_chkpnts= 'True';
Imax = 1;
if nargin == 0
    repPoints1= [-0.3375,-0.2625,0,0.0875,0.3125;
        123,73,0,13,97];
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    repPoints1= [ -0.2875 ,  -0.0875 ,        0  ,  0.1375 ,   0.3375;
        81.7839 ,  13.0408  ,  6.1338  , 23.7725,  111.5941];
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    rp1.p = avrg_par;
    
end
rp1.dE = 2.5;
rp1.dk = 0.1;
rp1.cut_direction=[0,1,0];

[parR1,sw1x,sw1y,sw1err,I1br1,I1br2]=fit_1SpinWave(data_source,[1,-1,0],rp1,'-b','rs',no_chkpnts,Imax);


if nargin == 0
    repPoints2 = [-0.2625,-0.0875,0,0.2875,0.3375;
        95,17,0,67,121];
else
    repPoints2 = [   -0.2625 ,  -0.1125,         0    ,0.1375 ,   0.3580;
        76.2500,   17.1092,    2.0244,   17.6590,  121.0000];
end
rp2=parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[1,0,0];

[parR2,sw2x,sw2y,sw2err,I2br1,I2br2]=fit_1SpinWave(data_source,[1,-1,0],rp2,'-k','ro',no_chkpnts,Imax);



if nargin == 0
    repPoints3 = [-0.3375,-0.1125,0,0.0875,0.3125;
        109,13,0,13,109];
else
    repPoints3 = [ -0.3125 ,  -0.1125  ,       0,    0.1375,    0.2500;
        105.3054, 19.4796, 4.1003, 17.4702, 54.7273];
end
rp3=parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[0,0,1];

[parR3,sw3x,sw3y,sw3err,I3br1,I3br2]=fit_1SpinWave(data_source,[1,1,0],rp3,'-g','ro',no_chkpnts,Imax);

%best=struct('par1',parR1,'br1',I1br1,'br2',I1br2);
%save('ei200_uvw100at1m10best','best1m10');

I1Max = max([I1br1.signal;I1br2.signal;I2br1.signal;I2br2.signal;I3br1.signal;I3br2.signal]);
disp(['Max Intensity: ', num2str(I1Max)]);
% I1br1 = I1br1/I1Max;
% I1br2 = I1br2/I1Max;
% I2br1 = I2br1/I1Max;
% I2br2 = I2br2/I1Max;
% I3br1 = I3br1/I1Max;
% I3br2 = I3br2/I1Max;


if nargin > 0 && numel(varargin{1}) < 3
    D=(parR1.p(3)+parR2.p(3)+parR3.p(3))/3/(2.1893^2);
    disp([' D of SQ avrg=',num2str(D)]);
    return;
end

acolor('r')
aline('-')
figH=dd(I1br1);
set(figH,'Name','Spin wave intensity along <1,0,0> directions around lattice point [1,-1,0]')

pd(I1br2)
acolor('g')
pd(I2br1)
pd(I2br2)
acolor('k')
pd(I3br1)
pd(I3br2)
ly 0 1.1;
lx 20 140;



D=(parR1.p(3)+parR2.p(3)+parR3.p(3))/3/(2.1893^2);
disp(' D of SQ avrg=%f',D)
