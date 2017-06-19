function refit_sw_findJBr110(varargin)
%
%
if nargin>0
    e_min = varargin{1};
    e_max = varargin{2};
else
    e_min  = -inf;
    e_max  = inf;
end
cut_prod = process_cuts();
cut_prod = cut_prod.refit_sw_findJ([1,1,0],'Fe_ei200',e_min,e_max);

cut_prod = process_cuts();
cut_prod = cut_prod.refit_sw_findJ([1,1,0],'Fe_ei401',e_min,e_max);

%cut_prod.extract_and_plot_sw_par(10,150);

