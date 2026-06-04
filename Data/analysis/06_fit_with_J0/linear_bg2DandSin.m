function z=linear_bg2DandSin(x,en,p)
% Linear background function
%
%   >> y = linear_bg (x,y,p)
%
% Input:
% =======
%   x   Array of x-axis values at which to evaluate function
%   p   Vector of parameters needed by the function:
%           y = p(1) + p(2)*x
%
% Output:
% ========
%   y   Array of calculated y-axis values


% if length(p)~=2
%     error('Input parameters must be a vector of length 2');
% end

z=p(1) + p(2).*x+p(3).*en;
gamma = p(5);
H = p(4);
A = p(6);
T = 8;
wdisp = H*abs(sin(0.5*pi*x));
z = z + A.* (dsho_over_eps (en, wdisp, gamma) .* bose_times_eps(en,T));
zer = wdisp < 1.e-3 & en < 0.1;
z(zer) = 0;