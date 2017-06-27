function cp=fit_sw_LocalJ3BraggEi400(varargin)
%
%

bragg_list = {[1,1,0],[1,-1,0],[2,0,0]};
%bragg_list = {[0,-1,1]};

cp = cuts_processor(bragg_list,'Fe_ei401');
cp.fit_par_range = [0,0,1,1,0,1,0,0,0,0];
cp.J1 = 0;
cp.J2 = 0;
cp = cp.refit_sw_findJ();

