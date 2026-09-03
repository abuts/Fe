function res = double_exp2D(~,en,par,varargin)

res = par(5)+par(1)*exp(par(2)*en)+par(3)*exp(par(4)*en);
%res = par(1)*exp(par(2)*en)+par(3)*exp(par(4)*en);
