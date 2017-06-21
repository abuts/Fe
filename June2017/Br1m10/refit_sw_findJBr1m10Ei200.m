function cp= refit_sw_findJBr1m10Ei200(varargin)
%
%

if nargin>0
    e_min = varargin{1};
    e_max = varargin{2};
else
    e_min  = -inf;
    e_max  = inf;
end
cp= process_cuts();
cp.fit_par_range = [0,0,1,1,0,1,1,1,1,1];
cp = cp.refit_sw_findJ([1,-1,0],'Fe_ei200',e_min,e_max);
