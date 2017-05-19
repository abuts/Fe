function weight = sw_parab(qh,qk,ql,en,par)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
h0 = par(4);
k0 = par(5);
l0 = par(6);
x = sqrt((qh-h0)^2+(qk-k0)^2+(ql-l0)^2);
parab = (par(1)+(par(2)+par(3)*x).*x);
abp

weight=(ampl/(sig*sqrt(2*pi)))*exp(-(en-en0).^2/(2*sig^2));

