data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei401.sqw';

no_chkpnts= 'True';
Imax = 0.2; % fitting considered wrong if intensity exceeds this value
repPoints1= [-0.4375,-0.1875,0,0.1875,0.4625;
    215,53,0,53,213];
dk = 0.1;
dE = 5;
rp1=parWithCorrections(repPoints1);
rp1.Esw_threshold=50;
rp1.cut_direction=[0,1,0];
rp1.dE =5;
rp1.dk =0.1;
[parR1,sw1x,sw1y,sw1err,I1br1,I1br2]=fit_1SpinWave(data_source,[2,0,0],rp1,'-b','rs',no_chkpnts,Imax);


repPoints2 = [-0.3375,-0.1375,0,0.2375,0.5125
    175,31,0,49,249];
rp2=parWithCorrections(repPoints2);
rp2.cut_direction=[1,0,0];
rp2.dE =5;
rp2.dk =0.1;
[parR2,sw2x,sw2y,sw2err,I2br1,I2br2]=fit_1SpinWave(data_source,[2,0,0],rp2,'-k','ro',no_chkpnts,Imax);


repPoints3 = [-0.3875,-0.1375,0,0.1625,0.3375;
    161,37,0,25,127];
rp3=parWithCorrections(repPoints3);
rp3.cut_direction=[0,0,1];
rp3.dE =5;
rp3.dk =0.1;

[parR3,sw3x,sw3y,sw3err,I3br1,I3br2]=fit_1SpinWave(data_source,[2,0,0],rp3,'-g','ro',no_chkpnts,Imax);



I1Max = max([I1br1.signal;I1br2.signal;I2br1.signal;I2br2.signal;I3br1.signal;I3br2.signal]);
disp(['Max Intensity: ', num2str(I1Max)]);
%I1Max=1;
% I1br1 = I1br1/I1Max;
% I1br2 = I1br2/I1Max;
% I2br1 = I2br1/I1Max;
% I2br2 = I2br2/I1Max;
% I3br1 = I3br1/I1Max;
% I3br2 = I3br2/I1Max;



acolor('r')
aline('-')
%dd(I1br1);
figH=dd(I1br1);
set(figH,'Name','Spin wave intensity along <1,0,0> directions around lattice point [2,0,0]')

pd(I1br2)
acolor('g')
pd(I2br1)
pd(I2br2)
acolor('k')
pd(I3br1)
pd(I3br2)
ly(0,1.1*I1Max);
lx 40 120;


% all cuts
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
figure('Name','Spin Wave Dispersion in <1,0,0> directions around lattice point [2,0,0] ');


xxi=-0.38:0.01:0.38;

plot(sw1x,sw1y,'ro');
hold on
plot(sw1err(1,:),sw1err(2,:),'-r');
yyi=fitpar(xxi,parR1.p);
plot(xxi,yyi,'-r');

plot(sw2x,sw2y,'gs');
yyi=fitpar(xxi,parR2.p);
plot(sw2err(1,:),sw2err(2,:),'-g');
plot(xxi,yyi,'-g');

plot(sw3x,sw3y,'bx');
yyi=fitpar(xxi,parR3.p);
plot(sw3err(1,:),sw3err(2,:),'-g');
plot(xxi,yyi,'-b');
lx -0.5 0.5

D=(parR1.p(3)+parR2.p(3)+parR3.p(3))/3/(2.1893^2);
disp([' D of SQ avrg=',num2str(D)])

