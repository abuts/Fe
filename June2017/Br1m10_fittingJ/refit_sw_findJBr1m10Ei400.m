function cp= refit_sw_findJBr1m10Ei400(varargin)
%
%


cp= cuts_processor([1,-1,0],'Fe_ei401');
cp.fit_par_range = [0,0,1,1,0,1,1,1,0,0];
cp = cp.refit_sw_findJ();
