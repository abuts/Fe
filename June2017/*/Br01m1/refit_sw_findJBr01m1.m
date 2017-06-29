function refit_sw_findJBr01m1(varargin)
%
%
if nargin>0
    e_min = varargin{1};
    e_max = varargin{2};
else
    e_min  = -inf;
    e_max  = inf;
end
cut_prod = cuts_processor();
cut_prod = cut_prod.refit_sw_findJ([0,1,-1],'Fe_ei200',e_min,e_max);

cut_prod.extract_and_plot_sw_par(10,150);

