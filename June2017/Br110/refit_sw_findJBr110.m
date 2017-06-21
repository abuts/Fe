function [cut_prod1,cut_prod2]=refit_sw_findJBr110(varargin)
%
%
if nargin>0
    e_min = varargin{1};
    e_max = varargin{2};
else
    e_min  = -inf;
    e_max  = inf;
end
cut_prod1= cuts_processor();
cut_prod1 = cut_prod1.refit_sw_findJ([1,1,0],'Fe_ei200',e_min,e_max);

cut_prod2 = cuts_processor();
%cut_prod2 = cut_prod2.refit_sw_findJ([1,1,0],'Fe_ei401',e_min,e_max);


