function cl = refit_sw_findJBr200(varargin)
%
%
if nargin>0
    e_min = varargin{1};
    e_max = varargin{2};
else
    e_min  = -inf;
    e_max  = inf;
end
%bragg_list = {[1,1,0],[1,-1,0],[2,0,0],[0,-1,-1],[0,1,-1],[0,-1,1]};

bragg_list = {[2,0,0]};

cl  = process_cuts();
cl = cl.refit_sw_findJ(bragg_list,'Fe_ei401',e_min,e_max);

%cut_prod.extract_and_plot_sw_par(10,150);
