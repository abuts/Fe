function [ampl,bg] = fit_GN_Ei800_allCuts()
Emax = 450;
dE   = 5;
Efit_min = 50;
Kun_width = 0.1;
Dqk = [-0.1,0.1];
Dql = [-0.1,0.1];
proj = {projection([1,-1,0],[1,1,0],'uoffset',[1,1,0]),projection([1,1,0],[1,-1,0],'uoffset',[1,-1,0]),projection([1,1,0],[1,-1,0],'uoffset',[0,0,0]),...
    projection([1,0,1],[1,0,-1]),projection([1,0,-1],[1,0,1]),...
    projection([0,1,1],[0,1,-1]),projection([0,1,-1],[0,1,1])};
kun_sym_dir = [1,1,1,2,2,3,3];
% proj = {projection([1,-1,0],[1,1,0]),projection([1,1,0],[1,-1,0])};
% kun_sym_dir = [1,1];

%pr = projection([1,-1,0],[1,1,0]);
dat = fullfile(pwd,'sqw','data','Fe_ei787.sqw');


w2all = cell(1,numel(proj));
w2tha = cell(1,numel(proj));
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

for i=1:numel(proj)
    w2all{i} = cut_sqw(dat,proj{i},[-4.5,0.02,4.5],Dqk ,Dql ,[0,dE,800]);
    w2all{i} = set_sample_and_inst(w2all{i},sample,@maps_instrument_for_tests,'-efix',600,'S');
    plot(w2all{i});
    lz  0 1
    w2tha{i} = sqw_eval(w2all{i},@disp_kun_calc,[1,1,2,kun_sym_dir(i),Kun_width]);
    plot(w2tha{i});
    lz  0 1
end
plot(w2all{1});
lx -4.5 2.5
lz  0 0.3
keep_figure;
plot(w2tha{1});
lx -4.5 2.5
lz  0 0.3
keep_figure;


%ly -2.5 2.5
en = Efit_min:dE:Emax;
nfp = numel(en);
sv_ampl = NaN*zeros(1,numel(en));
fit_err = NaN*zeros(1,numel(en));
bg_fit   = NaN*zeros(1,numel(en));
bg_err   = NaN*zeros(1,numel(en));
fgs = fig_spread('-tight');
for i=1:nfp
    cut2fit = cell(1,numel(proj));
    for j=1:numel(proj)
        cut2fit{j}  = cut_sqw(w2all{j},proj{j},[-3,0.02,3],Dqk ,Dql,[en(i)-dE,en(i)+dE]);
    end
    [A,err,bg_val,bg_er,fgs]=fit_encut(cut2fit,fgs,kun_sym_dir,Kun_width);
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

function [A,err,bg_val,bg_err,fgs]=fit_encut(en_cuts,fgs,kun_sym_dir,Kun_width )
%bg_val  =0;
%bg_err = 0;
acolor('k');
fh= plot(en_cuts{1});
for i=2:numel(en_cuts)
    pd(en_cuts{i});
end
kk = tobyfit(en_cuts{:});
fg_arr = cell(1,numel(kun_sym_dir));
fg_par = cell(1,numel(kun_sym_dir));
fg_free = cell(1,numel(kun_sym_dir));
bg_arr  = cell(1,numel(kun_sym_dir));
bg_par  = cell(1,numel(kun_sym_dir));
for i=1:numel(kun_sym_dir)
    fg_arr{i} = @disp_kun_calc;
    fg_par{i} = [1,1,2,kun_sym_dir(i),Kun_width];
    fg_free{i} = [1,0,0,0,0];
    bg_arr{i} = @(x,par)(par(1));
    bg_par{i} = 0;
end

kk = kk.set_fun(fg_arr,fg_par,fg_free);
kk = kk.set_bind ({1, [1,1]});

% set up its own initial background value for each background function
kk = kk.set_bfun(bg_arr,bg_par);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;20;1.e-4]);
%profile on;
%[w1d_arr_tf,fitpar]=kk.simulate;
[w1d_arr_tf,fitpar]=kk.fit;
acolor('r');
for i=1:numel(en_cuts)
    pl(w1d_arr_tf{i});
end
par = fitpar.p{1};
A   = abs(par(1));
sig = fitpar.sig{1};
err = sig(1);
bp = fitpar.bp{1};
bg_val = bp(1);
bsig = fitpar.bsig{1};
bg_err = bsig(1);
if exist('fgs','var')
    fgs = fgs.place_fig(fh);
end


