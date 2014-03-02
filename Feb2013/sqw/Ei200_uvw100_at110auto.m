function Ei200_uvw100_at110auto(varargin)

data_source= fullfile(pwd,'Fe_ei200.sqw');
avrg_par=[0,0,949.35];
no_chkpnts= 'True';
Imax = 1;
if nargin == 0
    repPoints1= [-0.2875,-0.0875,0,0.1375,0.3375;
        95,15,0,19,121];
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
[parR1,sw1x,sw1y,sw1err,I1br1,I1br2]=fit_1SpinWave(data_source,[1,1,0],rp1,'-b','rs',no_chkpnts,Imax);


if nargin == 0
    repPoints2 = [-0.2625,-0.1125,0,0.1375,0.3625;
        95,19,0,19,123];
else
    repPoints2 = [   -0.2625 ,  -0.1125,         0    ,0.1375 ,   0.3580;
        76.2500,   17.1092,    2.0244,   17.6590,  121.0000];
end
rp2=parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;

rp2.cut_direction=[1,0,0];


[parR2,sw2x,sw2y,sw2err,I2br1,I2br2]=fit_1SpinWave(data_source,[1,1,0],rp2,'-k','ro',no_chkpnts,Imax);

if nargin == 0
    repPoints3 = [-0.3125,-0.1125,0,0.1375,0.25;
        109,21,0,19,84];    
else
    repPoints3 = [ -0.3125 ,  -0.1125  ,       0,    0.1375,    0.2500;
        105.3054, 19.4796, 4.1003, 17.4702, 54.7273];
end
rp3=parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;

rp3.cut_direction=[0,0,1];

[parR3,sw3x,sw3y,sw3err,I3br1,I3br2]=fit_1SpinWave(data_source,[1,1,0],rp3,'-g','ro',no_chkpnts,Imax);

%best110=struct('par1',parR1,'br1',I1br1,'br2',I2br1);
%save('ei200_uvw100at110best','best110');

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
set(figH,'Name','Spin wave intensity along <1,0,0> directions around lattice point [1,1,0]')

pd(I1br2)
acolor('g')
pd(I2br1)
pd(I2br2)
acolor('b')
pd(I3br1)
pd(I3br2)
ly(0,1.1*I1Max);
lx 20 140;
parR3.result_pic = parR3.result_pic.place_pic(figH,'-rize');

% all cuts
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
f3=figure;
parR3.result_pic = parR3.result_pic.place_pic(f3,'-rize');

xxi=-0.38:0.01:0.38;

plot(sw1x,sw1y,'ro');
hold on
plot(sw1err(1,:),sw1err(2,:),'-r');
yyi=fitpar(xxi,parR1.p);
plot(xxi,yyi,'-r');

plot(sw2x,sw2y,'gs');
plot(sw2err(1,:),sw2err(2,:),'-g');
yyi=fitpar(xxi,parR2.p);
plot(xxi,yyi,'-g');

plot(sw3x,sw3y,'bx');
plot(sw3err(1,:),sw3err(2,:),'-b');
yyi=fitpar(xxi,parR3.p);
plot(xxi,yyi,'-b');

D=(parR1.p(3)+parR2.p(3)+parR3.p(3))/3/(2.1893^2);
disp([' D of SQ avrg=',num2str(D)])

