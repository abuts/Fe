function cp=fit_sw_LocalJ8BraggEi200And400(varargin)
%
%

bragg_list = {[1,1,0],[1,-1,0],[2,0,0],...
    [0,-1,-1],[1,0,-1],[0,1,-1],...
    [0,-1,1],[1,0,1]};
%bragg_list = {[0,-1,1]};

cp = cuts_le_processor(bragg_list,{'Fe_ei200','Fe_ei401'});
%cp = cuts_processor(bragg_list,'Fe_ei401');
cp = cp.refit_sw_findJ();

