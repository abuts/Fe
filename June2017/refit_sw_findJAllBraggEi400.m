function cp = refit_sw_findJAllBraggEi400(varargin)
%
%
if nargin>0
    e_min = varargin{1};
    e_max = varargin{2};
else
    e_min  = -inf;
    e_max  = inf;
end
bragg_list = {[1,1,0],[1,-1,0],[2,0,0],[0,-1,-1],[0,1,-1],[0,-1,1],[1,0,1]};
%bragg_list = {[0,-1,1]};

cp = process_cuts();
cp = cp.refit_sw_findJ(bragg_list,'Fe_ei401',e_min,e_max);
