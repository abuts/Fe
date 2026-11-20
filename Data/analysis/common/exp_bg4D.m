function weight=exp_bg4D(~,~,~,en,p,varargin)
% Interpolating background function
%
%   >> y = exp_bg4D (x,y,p)
%
% Input:
% =======
%   x   Array of x-axis values at which to evaluate function
%
% Output:
% ========
%   y   Array of calculated y-axis values
par = varargin{1};
x = par.x;
y = par.signal;
if numel(x) == numel(y)+1
    x  = 0.5*(x(1:end-1)+x(2:end));
end
weight =interp1(x,y,en,'linear','extrap');
