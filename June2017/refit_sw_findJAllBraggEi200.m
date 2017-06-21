function cut_prod=refit_sw_findJAllBraggEi200(varargin)
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

cut_prod = process_cuts();
cut_prod.fit_par_range = [0 0 1 1 0 1 1 1 1 1];
cut_prod = cut_prod.refit_sw_findJ(bragg_list,'Fe_ei200',e_min,e_max);



