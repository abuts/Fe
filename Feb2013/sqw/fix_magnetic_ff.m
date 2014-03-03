function [I_corrected,dI_cor,form_factor]= fix_magnetic_ff( q,I,dI,u0,direction,rlu2u,varargin )
% function corrects for magnetic form factor decay for given fit
% on the basis of theoretical form factor
% 

%
%J0
% data copied from https://www.ill.eu/sites/ccsl/ffacts/ffachtml.html 
% compared against 
% http://it.iucr.org/Cb/ch4o4v0001/sec4o4o5/
% and Mantid:
%0.0706,35.008,0.3589,15.358,0.5819,5.561,-0.0114,0.1398
%ion	A        a       B      b       C       c        D           e
%Fe0 	0.0706 	35.008 	0.3589 	15.358 	0.5819 	5.561 	-0.0114 	0.1398
A=0.0706; a=35.008; B=0.3589; b=15.358; C=0.5819;c=5.561; D=-0.0114;
%------------------------------------------------------------------------
% data copied from https://www.ill.eu/sites/ccsl/ffacts/ffachtml.html
%J2
%        A 	     a     	    B 	     b      	C   	c 	      D         e
%Fe0 	1.9405 	18.473 	    1.9566     6.323 	0.5166 	 2.161  	0.0036  0.0394
% Mantid
%1.9405,18.473,1.9566,6.323,0.5166,2.161,0.0036,0.0394
A2=1.9405;   a2 = 18.4733; B2 = 1.9566;b2 = 6.323;C2 = 0.5166;c2 = 2.1607; D2 = 0.0036;

% where X2 is sin(Theta)/Lambda in A^-1
J0_ff = @(x2)((A*exp(-a*x2)+B*exp(-b*x2)+C*exp(-c*x2)+D));
J2_ff = @(x2)(((A2*exp(-a2*x2)+B2*exp(-b2*x2)+C2*exp(-c2*x2)+D2).*x2));
% xt=0:0.01:1;
% yt=mag_ff(xt);
% plot(xt,yt);

k0 = u0(1:3)';
ki = (direction/sqrt(sum(direction.^2)));

q2_atCut=@(x)(sum(((k0+ki*x).*rlu2u(1:3)/(4*pi)).^2));

qt=arrayfun(q2_atCut,q);
if nargin<7
    form_factor=J0_ff(qt).^2;
else
    form_factor=J0_ff(qt).^2+ J2_ff(qt).^2;
end

% figure;
% plot(q,form_factor);

I_corrected = I./form_factor;
dI_cor   = dI./form_factor;
end

