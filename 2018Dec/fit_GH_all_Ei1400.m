function [ampl,bg] = fit_GH_all_Ei1400()
Emax = 400;
dE   = 5;
Efit_min = 70;
Dqh = [0.85,1.15];
Dqk = [0.85,1.15];

pr = projection([1,0,0],[0,1,0]);
dat = fullfile(pwd,'sqw','data','Fe_ei1371_base.sqw');
s_1 = symop([1,0,0], [0,0,1], [1,0,0]);
s_2 = symop([1,0,0], 90, [1,0,0]);
s_3 = symop([1,0,0], -90, [1,0,0]);
w2ss = cut_sqw_sym(dat,pr,Dqh ,Dqk ,[-3,0.05,3],[0,dE,Emax],{s_1,s_2,s_3});

plot(w2ss);
lx -3 3
lz 0 0.5

sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
w2ss = set_sample_and_inst(w2ss,sample,@maps_instrument_for_tests,'-efix',600,'A');



%ly -2.5 2.5
en = Efit_min:dE:Emax;
nfp = numel(en);
sv_ampl = NaN*zeros(1,numel(en));
fit_err = NaN*zeros(1,numel(en));
bg_fit   = NaN*zeros(1,numel(en));
bg_err   = NaN*zeros(1,numel(en));
fgs = fig_spread('-tight');
for i=1:nfp
    cut2fit  = cut_sqw(w2ss,pr,Dqh,Dqk,[-3,0.05,3],[en(i)-dE,en(i)+dE]);
    [A,err,bg_val,bg_er,fgs]=fit_encut(cut2fit,fgs);
    sv_ampl(i) = A;
    fit_err(i) = err;
    bg_fit(i) = bg_val;
    bg_err(i) = bg_er;
end
acolor('b')
errorbar(en,sv_ampl,fit_err)
hold on
acolor('r')
errorbar(en,bg_fit,bg_err)
%
ampl = IX_dataset_1d(en,sv_ampl,fit_err);
acolor('b')
figure;
pd(ampl);
acolor('r')
bg = IX_dataset_1d(en,bg_fit,bg_err);
pd(bg);

function [A,err,bg_val,bg_err,fgs]=fit_encut(en_cut,fgs)
%bg_val  =0;
%bg_err = 0;
acolor('k');
fh= plot(en_cut);
kk = tobyfit(en_cut );
kk = kk.set_fun(@disp_dft_parameterized,[0.1,1],[1,0]);
% set up its own initial background value for each background function
kk = kk.set_bfun(@(x,par)(par(1)),0);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',0,'fit_control_parameters',[1.e-4;20;1.e-4]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;20;1.e-4]);
%profile on;
[w1d_arr_tf,fitpar]=kk.fit;
acolor('r');
pl(w1d_arr_tf);
A   = abs(fitpar.p(1));
err = fitpar.sig(1);
bg_val = fitpar.bp(1);
bg_err = fitpar.bsig(1);
if exist('fgs','var')
    fgs = fgs.place_fig(fh);
end


