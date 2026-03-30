function z=exp_bg2D(x,y,p)
% Linear background function
%
%   >> y = exp_bg2D (x,y,p)
%
% Input:
% =======
%   x   Array of x-axis values at which to evaluate function
%
% Output:
% ========
%   y   Array of calculated y-axis values

xp = y-50;
z= p(1)*(exp(-abs(p(2)).*xp) + p(3)*exp(-abs(p(4)).*xp));

