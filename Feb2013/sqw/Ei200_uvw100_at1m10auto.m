data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw';

no_chkpnts= 'Ture'; %[]; %'True';
Imax = 1;
repPoints1= [-0.3375,-0.2625,0,0.0875,0.3125;
    123,73,0,13,97];
rp1=parWithCorrections(repPoints1);
rp1.Esw_threshold=40;
rp1.cut_direction=[0,1,0];
rp1.dk=0.05;
rp1.dE=2;
[parR1,sw1x,sw1y,sw1err,I1br1,I1br2]=fit_1SpinWave(data_source,[1,-1,0],rp1,'-b','rs',no_chkpnts,Imax);


repPoints2 = [-0.2625,-0.0875,0,0.2875,0.3375;
    95,17,0,67,121];
rp2=parWithCorrections(repPoints2);
rp2.Esw_threshold=40;
rp2.cut_direction=[1,0,0];
rp2.dk=0.05;
rp2.dE=2;
[parR2,sw2x,sw2y,sw2err,I2br1,I2br2]=fit_1SpinWave(data_source,[1,-1,0],rp2,'-k','ro',no_chkpnts,Imax);


repPoints3 = [-0.3375,-0.1125,0,0.0875,0.3125;
    109,13,0,13,109];
rp3=parWithCorrections(repPoints3);
rp3.Esw_threshold=40;
rp3.cut_direction=[0,0,1];
rp3.dk=0.05;
rp3.dE=2;

[parR3,sw3x,sw3y,sw3err,I3br1,I3br2]=fit_1SpinWave(data_source,[1,1,0],rp3,'-g','ro',no_chkpnts,Imax);

best=struct('par1',parR1,'br1',I1br1,'br2',I1br2);
save('ei200_uvw100at1m10best','best1m10');

I1Max = max([I1br1.signal;I1br2.signal;I2br1.signal;I2br2.signal;I3br1.signal;I3br2.signal]);
disp(['Max Intensity: ', num2str(I1Max)]);
% I1br1 = I1br1/I1Max;
% I1br2 = I1br2/I1Max;
% I2br1 = I2br1/I1Max;
% I2br2 = I2br2/I1Max;
% I3br1 = I3br1/I1Max;
% I3br2 = I3br2/I1Max;



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

