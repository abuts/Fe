function cp= refit_sw_Br1m10Ei200_WithEi400J(varargin)
%
%
if nargin>0
    cp = varargin{1};
else
    cp= cuts_processor([1,-1,0],'Fe_ei200');
end
cp.fit_par_range = [0,0,1,1,0,0,0,0,0,0];
cp.J0 = 32.074;
cp.J1 = 18.859;
cp.J2 = 9.1856;
cp.J3 = -4.7538;
cp.J4 = -4.1869;

cp = cp.refit_sw_findJ();
