function param = fit_parabola( x,y,varargin)
% Simple sctipt to fit parabola to a data

if nargin == 2
    x2 = x.*x;
    x3 = x2.*x;
    x4 = x3.*x;
    
    Sx0 = numel(x);
    Sx1 = sum(x);
    Sx2 = sum(x2);
    Sx3 = sum(x3);
    Sx4 = sum(x4);
    Sy  = sum(y);
    Sxy = sum(y.*x);
    Sx2y= sum(y.*x2);
    
    A=[Sx0,Sx1,Sx2;Sx1,Sx2,Sx3;Sx2,Sx3,Sx4];
    B=[Sy;Sxy;Sx2y];
    
    
    param = linsolve(A,B);
else
    parabola = @(x,par)(par(1)+(par(2)+par(3)*x).*x);
    s.x = x;
    s.y = y;
    s.e = varargin{1};
    [~,fit_par] = fit(s,parabola,[1,1,1]);
    param = fit_par.p;
end

