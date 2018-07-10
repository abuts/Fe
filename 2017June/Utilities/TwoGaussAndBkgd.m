function y = TwoGaussAndBkgd(x, p, varargin)

y=(exp(-0.5*((x-p(2))/p(3)).^2)+exp(-0.5*((x+p(2))/p(3)).^2))*(p(1)/sqrt(2*pi)/p(3)) + (p(4)+x*p(5));
