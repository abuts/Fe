data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw';

no_chkpnts= 'True';
Imax = 1; % the intensity rejected as wrong
repPoints1= [-0.2625,-0.0625,0,0.1375,0.3875; 
             87,13,0,15,123];
dk = 0.05;
dE = 2;
[parR1,sw1x,sw1y,sw1err,I1br1,I1br2]=fit_1SpinWave(data_source,dk,dE,[1,1,0],[1,1,0],repPoints1,'-b','rs',no_chkpnts,Imax);


repPoints2 = [-0.3125,-0.1375,0,0.1375,0.3375;
               109,17,0,15,109];
[parR2,sw2x,sw2y,sw2err,I2br1,I2br2]=fit_1SpinWave(data_source,dk,dE,[1,1,0],[1,-1,0],repPoints2,'-k','go',no_chkpnts,Imax);


repPoints3 = [-0.2625,-0.0875,0,0.1125,0.3875;
              101,11,0,11,119];
[parR3,sw3x,sw3y,sw3err,I3br1,I3br2]=fit_1SpinWave(data_source,dk,dE,[1,1,0],[1,0,1],repPoints3,'-g','rx',no_chkpnts,Imax);
           
repPoints4 = [-0.3125,-0.0875,0,0.0875,0.3125;
              99,13,0,13,117];
[parR4,sw4x,sw4y,sw4err,I4br1,I4br2]=fit_1SpinWave(data_source,dk,dE,[1,1,0],[1,0,-1],repPoints4,'-r','bd',no_chkpnts,Imax);

repPoints5 = [-0.3125,-0.0875,0,0.1375,0.3375;
              99,13,0,15,119];
[parR5,sw5x,sw5y,sw5err,I5br1,I5br2]=fit_1SpinWave(data_source,dk,dE,[1,1,0],[0,1,1],repPoints5,'-g','rx',no_chkpnts,Imax);
           
repPoints6 = [-0.3125,-0.0875,0,0.0875,0.3375;
              101,15,0,13,117];
[parR6,sw6x,sw6y,sw6err,I6br1,I6br2]=fit_1SpinWave(data_source,dk,dE,[1,1,0],[0,1,-1],repPoints6,'-r','bd',no_chkpnts,Imax);


I1Max = max([I1br1.signal;I1br2.signal;I2br1.signal;I2br2.signal;I3br1.signal;I3br2.signal;I4br1.signal;I4br2.signal;I5br1.signal;I5br2.signal;I6br1.signal;I6br2.signal]);
I1Min = min([I1br1.signal;I1br2.signal;I2br1.signal;I2br2.signal;I3br1.signal;I3br2.signal;I4br1.signal;I4br2.signal;I5br1.signal;I5br2.signal;I6br1.signal;I6br2.signal]);
disp(['Max Intensity: ', num2str(I1Max)]);
I1br1 = I1br1/I1Max;
I1br2 = I1br2/I1Max;
I2br1 = I2br1/I1Max;
I2br2 = I2br2/I1Max;
I3br1 = I3br1/I1Max;
I3br2 = I3br2/I1Max;
I4br1 = I4br1/I1Max;
I4br2 = I4br2/I1Max;
I5br1 = I5br1/I1Max;
I5br2 = I5br2/I1Max;
I6br1 = I6br1/I1Max;
I6br2 = I6br2/I1Max;



acolor('r')
aline('-')
dd(I1br1);
figH=dd(I1br1);
set(figH,'Name','Spin wave intensity along <1,0,0> directions around lattice point [1,1,0]')

pd(I1br2)
acolor('g')
pd(I2br1)
pd(I2br2)
acolor('blue')
pd(I3br1)
pd(I3br2)
acolor('k')
pd(I4br1)
pd(I4br2)

acolor('m')
pd(I5br1)
pd(I5br2)
acolor('y')
pd(I6br1)
pd(I6br2)

ly(0.8*I1Min/I1Max,1.2);

% all cuts 
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
figure('Name','Spin Wave Dispersion in <1,0,0> directions around lattice point [1,1,0] ');

xxi=-0.38:0.01:0.38;

plot(sw1x,sw1y,'ro');
hold on
yyi=fitpar(xxi,parR1);
plot(xxi,yyi,'-r');

plot(sw2x,sw2y,'gs');
yyi=fitpar(xxi,parR2);
plot(xxi,yyi,'-g');

plot(sw3x,sw3y,'bx');
yyi=fitpar(xxi,parR3);
plot(xxi,yyi,'-b');

plot(sw4x,sw4y,'kd');
yyi=fitpar(xxi,parR4);
plot(xxi,yyi,'-k');

plot(sw5x,sw5y,'yo');
yyi=fitpar(xxi,parR5);
plot(xxi,yyi,'-y');

plot(sw6x,sw6y,'rd');
yyi=fitpar(xxi,parR6);
plot(xxi,yyi,'-r');


D=(parR1(3)+parR2(3)+parR3(3)+parR4(3)+parR5(3)+parR6(3))/6/(2.1893^2);
disp([' D of SQ avrg=',num2str(D)])

