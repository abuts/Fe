function fh = plot_with_dG(obj,varargin)
%
% if -noextcted option is specified, plot only
% fittet SW and backgoud
accepted_options = {'-noextracted'};
[ok,mess,no_extracted]...
    = parse_char_options(varargin,accepted_options);
if ~ok
    error('EN_CUT_BLOCK:invalid_argument',mess);
end
kk = tobyfit(obj.cuts_list);

fp_arr_sim = obj.fit_param.p;
fp_arr_sim(6) = fp_arr_sim(6)+5;
kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),obj.fit_param.bp);
kk = kk.set_fun(@sqw_iron,fp_arr_sim,[0,0,1,1,0,1,0,0,0,0]);
w1D_arr1_sim=kk.simulate('comp');
fp_arr_sim = obj.fit_param.p;
fp_arr_sim(6) = fp_arr_sim(6)-5;
kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),obj.fit_param.bp);
kk = kk.set_fun(@sqw_iron,fp_arr_sim,[0,0,1,1,0,1,0,0,0,0]);
w1D_arr2_sim=kk.simulate('comp');


acolor('k')
aline('-')
fh=plot(obj.cuts_list_(1));
for i=2:numel(obj.cuts_list_)
    pd(obj.cuts_list_{i})
end
acolor('r')
pl(obj.fits_list(1).sum)
pl(obj.fits_list(1).back)

acolor('g')
pl(w1D_arr1_sim.sum)
acolor('b')
pl(w1D_arr2_sim.sum)
