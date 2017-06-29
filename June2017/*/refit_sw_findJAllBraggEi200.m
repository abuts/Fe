function cut_prod=refit_sw_findJAllBraggEi200(varargin)
%
%

bragg_list = {[1,1,0],[1,-1,0],[2,0,0],[0,-1,-1],[0,1,-1],[0,-1,1],[1,0,1]};
%bragg_list = {[0,-1,1]};

cut_prod = cuts_processor(bragg_list,'Fe_ei200');
cut_prod.fit_par_range = [0 0 1 1 0 1 1 1 0 0];
cut_prod = cut_prod.refit_sw_findJ();



