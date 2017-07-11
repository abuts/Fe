disp=1000;
g=1000;
Kb=8.6173324e-2;
T=8;
KbT = Kb*T;

f = @(e,g)(e.*g.*disp./((e.^2 - disp.^2).^2+4*(g.*e).^2)./(1-exp(-e/KbT)));

e = 1:1:100;
g = 1:1:100;
[X,Y] = meshgrid(e,g);
ff = f(X,Y);
%ff = reshape(ff,numel(e),numel(g));
%
surf(ff)