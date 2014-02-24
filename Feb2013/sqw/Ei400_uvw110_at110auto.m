data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei401.sqw';

no_chkpnts= 'false';
Imax = 0.5; % the intensity rejected as wrong
repPoints1= [-0.3375,-0.1625,0,0.1625,0.4625;
    121,25,0,27,193];
dk = 0.1;
dE = 3;
rp1=parWithCorrections(repPoints1);
rp1.cut_direction=[1,1,0];
rp1.dE =3;
rp1.dk =0.1;
[parR1,sw1x,sw1y,sw1err,I1br1,I1br2]=fit_1SpinWave(data_source,dk,dE,[1,1,0],rp1,'-b','rs',no_chkpnts,Imax);


repPoints2 = [-0.3625,-0.0875,0,0.2125,0.4125;
    157,21,0,33,165];
rp2=parWithCorrections(repPoints2);
rp2.cut_direction=[1,-1,0];
rp2.dE =3;
rp2.dk =0.1;
[parR2,sw2x,sw2y,sw2err,I2br1,I2br2]=fit_1SpinWave(data_source,[1,1,0],rp2,'k','go',no_chkpnts,Imax);


repPoints3 = [-0.3125,-0.1375,0,0.1625,0.4375;
    141,25,0,25,183];
rp3=parWithCorrections(repPoints3);
rp3.cut_direction=[1,0,1];
rp3.dE =3;
rp3.dk =0.1;

[parR3,sw3x,sw3y,sw3err,I3br1,I3br2]=fit_1SpinWave(data_source,[1,1,0],rp3,'g','rx',no_chkpnts,Imax);

repPoints4 = [-0.3625,-0.1625,0,0.1375,0.3875;
    141,19,0,25,179];
rp4=parWithCorrections(repPoints4);
rp4.cut_direction=[1,0,-1];
rp4.dE =3;
rp4.dk =0.1;
[parR4,sw4x,sw4y,sw4err,I4br1,I4br2]=fit_1SpinWave(data_source,[1,1,0],rp4,'r','bd',no_chkpnts,Imax);

repPoints5 = [-0.3375,-0.1125,0,0.1625,0.4375;
    145,25,0,23,177];
rp5=parWithCorrections(repPoints5);
rp5.cut_direction=[0,1,1];
rp5.dE =3;
rp5.dk =0.1;

[parR5,sw5x,sw5y,sw5err,I5br1,I5br2]=fit_1SpinWave(data_source,[1,1,0],rp5,'g','rx',no_chkpnts,Imax);

repPoints6 = [-0.3625,-0.1625,0,0.1375,0.3875;
    143,29,0,21,177];
rp6=parWithCorrections(repPoints6);
rp6.cut_direction=[0,1,-1];
rp6.dE =3;
rp6.dk =0.1;
[parR6,sw6x,sw6y,sw6err,I6br1,I6br2]=fit_1SpinWave(data_source,[1,1,0],rp6,'r','bd',no_chkpnts,Imax);





acolor('r')
aline('-')
%dd(I1br1);
figH=dd(I1br1);
set(figH,'Name','Spin wave intensity along <1,1,0> directions around lattice point [1,1,0]')

pd(I1br2)
acolor('g')
pd(I2br1)
pd(I2br2)
acolor('b')
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
ly 0 1.1;
lx 20 140;



% all cuts
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
figure('Name','Spin Wave Dispersion in <1,1,0> directions around lattice point [1,1,0] ');
%figure;

xxi=-0.38:0.01:0.38;

plot(sw1x,sw1y,'ro');
hold on
plot(sw1err(1,:),sw1err(2,:),'-r');
yyi=fitpar(xxi,parR1);
plot(xxi,yyi,'-r');

plot(sw2x,sw2y,'gs');
plot(sw2err(1,:),sw2err(2,:),'-g');
yyi=fitpar(xxi,parR2);
plot(xxi,yyi,'-g');

plot(sw3x,sw3y,'bx');
plot(sw3err(1,:),sw3err(2,:),'-b');
yyi=fitpar(xxi,parR3);
plot(xxi,yyi,'-b');

plot(sw4x,sw4y,'kd');
plot(sw4err(1,:),sw4err(2,:),'-k');
yyi=fitpar(xxi,parR4);
plot(xxi,yyi,'-k');

plot(sw5x,sw5y,'yo');
yyi=fitpar(xxi,parR5);
plot(sw5err(1,:),sw5err(2,:),'-y');
plot(xxi,yyi,'-y');

plot(sw6x,sw6y,'rd');
plot(sw6err(1,:),sw6err(2,:),'-r');
yyi=fitpar(xxi,parR6);
plot(xxi,yyi,'-r');
lx -0.5 0.5


D=(parR1(3)+parR2(3)+parR3(3)+parR4(3)+parR5(3)+parR6(3))/6/(2.1893^2);
disp([' D of SQ avrg=',num2str(D)])

