function weight = linterp_bg(~,~,~,en,par,varargin)
% Calculate background on the basis of linear interpolation over input 
% IX_dataset_1d

x = par.x;
y = par.signal;
weight =interp1(x,y,en,'linear','extrap');
end