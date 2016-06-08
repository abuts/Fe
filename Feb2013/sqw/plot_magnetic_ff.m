function plot_magnetic_ff
%
% conversion Q_RLU to q_A
scale = ones(1,3)*2.1893;
% vavevector (in rlu)
q0 = -5:0.1:5;
% dummy intensity
I  = ones(1,numel(q0));
dI = I;
% irrelevant here but important when plotting magnetic ff corrections
% around bragg
direction=[1,0,0];
% point to plot magnetic ff around
uoffset  = [0,0,0]';

[~,~,mag_ff]=fix_magnetic_ff(q0,I,dI,uoffset,direction,scale);

qp=q0*2.1893;

point =parWithCorrections.getTextFromVector(uoffset);
dir = parWithCorrections.getTextFromVector(direction);
figure('Name',['magnetic form factor corrections for iron at ',point,' dir: ',dir]);
plot(qp,mag_ff,'b')
[~,~,mag_ff]=fix_magnetic_ff(q0,I,dI,uoffset,direction,scale,'j2');
hold on
plot(qp,mag_ff,'r')
xlabel('A^-1')
%xlabel('rlu')

uoffset  = [1,0,0]';
direction = [0,1,0];
[~,~,mag_ff]=fix_magnetic_ff(q0,I,dI,uoffset,direction,scale);

qp=q0; %*2.1893;
point =parWithCorrections.getTextFromVector(uoffset);
dir = parWithCorrections.getTextFromVector(direction);
figure('Name',['magnetic form factor corrections for iron at ',point,' dir: ',dir]);
plot(qp,mag_ff,'b')
xlabel('A^-1')
%xlabel('rlu')
[~,~,mag_ff]=fix_magnetic_ff(q0,I,dI,uoffset,direction,scale,'j2');
hold on
plot(qp,mag_ff,'r')
