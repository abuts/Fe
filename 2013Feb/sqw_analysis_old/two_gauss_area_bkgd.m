function y = two_gauss_area_bkgd(x, p)
% Gaussian on linear background. Fits area and width (cf. gauss_bkgd which fits height and width)
% 
%   >> y = gauss_area_bkgd(x,p)
%   >> [y, name, pnames, pin] = gauss_area_bkgd(x,p,flag)
%
% Input:
% =======
%   x   Vector of x-axis values at which to evaluate function
%   p   Vector of parameters needed by the function:
%           p = [area, centre, st_deviation, area, centre, st_deviation, bkgd_const, bkgd_slope]
%
% Output:
% ========
%   y       Vector of calculated y-axis values

if nargin==2
    % Simply calculate function at input values
    y=(abs(p(1))/(p(3)*sqrt(2*pi)))*exp(-0.5*((x-p(2))/p(3)).^2) +...
        (abs(p(4))/(p(6)*sqrt(2*pi)))*exp(-0.5*((x-p(5))/p(6)).^2) + (p(7)+x*p(8));
else
    error('Oh crap...')
end
