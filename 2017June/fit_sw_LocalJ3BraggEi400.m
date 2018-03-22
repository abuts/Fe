function cp=fit_sw_LocalJ3BraggEi400(varargin)
%
%

%bragg_list = {[1,1,0],[1,-1,0],[2,0,0]};
bragg_list = {[0,-1,1]};

cp = cuts_le_processor(bragg_list,'Fe_ei401');
%cp = cuts_processor(bragg_list,'Fe_ei401');
cp = cp.refit_sw_findJ();

