function weight = linterp_bg(~,~,~,en,par,varargin)
% Calculate background on the basis of linear interpolation over input 
% IX_dataset_1d

x = par.x;
y = par.signal;
if numel(x) == numel(y)+1
    x  = 0.5*(x(1:end-1)+x(2:end));
end
weight =interp1(x,y,en,'linear','extrap');
end