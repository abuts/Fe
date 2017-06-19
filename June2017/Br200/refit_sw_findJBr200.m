function refit_sw_findJBr200(varargin)
%
%
if nargin>0
    e_min = varargin{1};
    e_max = varargin{2};
else
    e_min  = -inf;
    e_max  = inf;
end
cuts_list = containers.Map();
%bragg_list = {[1,1,0],[1,-1,0],[2,0,0],[0,-1,-1],[0,1,-1],[0,-1,1]};
bragg_list = {[2,0,0]};
file_list = {'Fe_ei401'};

