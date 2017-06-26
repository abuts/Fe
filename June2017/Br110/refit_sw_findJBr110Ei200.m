function cp= refit_sw_findJBr110Ei200(varargin)
%
%

cp= cuts_processor([1,1,0],'Fe_ei200');
cp.fit_par_range = [0,0,1,1,0,1,0,0,0,0];
cp.J1 = 0;
cp.J2 = 0;
cp = cp.refit_sw_findJ();
