function cut_prod=fit_sw_LocalJ3BraggEi400(varargin)
%
%

bragg_list = {[1,1,0],[1,-1,0],[2,0,0]};
%bragg_list = {[0,-1,1]};

cut_prod = cuts_processor(bragg_list,'Fe_ei401');
cut_prod = cut_prod.refit_sw_findJ();

