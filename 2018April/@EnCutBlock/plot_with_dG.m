function fh = plot_with_dG(obj,varargin)
% Plot enCut with inital fit and complemet it with
% the plots of the fits, made within the routine.
%
% The fit parameters should be changed within the routine
%
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
%fp_arr_sim(3) = 10;
fp_arr_sim= [   1.0000    8.0000  100.0000    1.4038*1.25         0   34.6588         0         0         0   0 ];

kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),obj.fit_param.bp);
kk = kk.set_fun(@sqw_iron,fp_arr_sim,[0,0,0,1,0,1,0,0,0,0]);
[w1D_arr1_sim,fitpar1]=kk.simulate('comp');
%[w1D_arr1_sim,fitpar1]=kk.fit('comp');
disp('initial fit:');
disp(obj.fit_param.p)
disp('shifted + fit (green):');
disp(fitpar1.p);
fp_arr_sim = obj.fit_param.p;
% fp_arr_sim(3) = 100;
fp_arr_sim=[1.0000    8.0000   10.0000    0.5642*0.74         0   29.7438         0         0         0     0];

kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),obj.fit_param.bp);
kk = kk.set_fun(@sqw_iron,fp_arr_sim,[0,0,0,1,0,1,0,0,0,0]);
[w1D_arr2_sim,fitpar2]=kk.simulate('comp');
%[w1D_arr2_sim,fitpar2]=kk.fit('comp');
disp('initial fit:');
disp(obj.fit_param.p)
disp('shifted - fit (blue):');
disp(fitpar2.p);

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
