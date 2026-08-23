function res = double_exp2D(~,en,par,varargin)

%res = par(5)+abs(par(1))*exp(par(2)*en)+abs(par(3))*exp(par(4)*en);
res = abs(par(1))*exp(par(2)*en)+abs(par(3))*exp(par(4)*en);
