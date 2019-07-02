function [ampl,bg] = fit_GN_all_Ei800()
Emax = 450;
dE   = 5;
Efit_min = 50;
Dqk = [0.9,1.1];
Dql = [-0.1,0.1];
%proj = {projection([1,-1,0],[1,1,0]),projection([1,1,0],[1,-1,0]),;
pr = projection([1,-1,0],[1,1,0]);
dat = fullfile(pwd,'sqw','data','Fe_ei787.sqw');

w2s = cut_sqw(dat,pr,[-4.5,0.02,4.5],Dqk ,Dql ,[0,dE,Emax]);
bg = cut_sqw(dat,pr,[-4.5,-2.5],Dqk ,Dql,[0,dE,Emax]);
if sum(bg.data.npix)>0
    bgc = replicate(bg,w2s );
    %w2ssc  = w2ss;
    w2sc  = w2s -bgc;
%     mi = MagneticIons('Fe0');
%    w2sc  = mi.correct_mag_ff(w2sc  );    
    plot(w2sc); 
    
    lx -2.5 2.5
    lz 0 0.3    
end


plot(w2s);
lx -2.5 2.5
lz 0 0.3
keep_figure;
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
w2s = set_sample_and_inst(w2s,sample,@maps_instrument_for_tests,'-efix',600,'S');

w2th = sqw_eval(w2s,@disp_kun_calc,[0.045,1,2,1,0.2]);
bg = cut_sqw(w2th,pr,[-4.5,-2.5],Dqk ,Dql,[0,dE,Emax]);
bgc = replicate(bg,w2th);
w2th = w2th - bgc;
plot(w2th);
lx -2.5 2.5
lz 0 0.3
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
    cut2fit  = cut_sqw(w2s,pr,[-3,0.02,3],Dqk ,Dql,[en(i)-dE,en(i)+dE]);
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
kk = kk.set_fun(@disp_kun_calc,[0.045,1,2,1,0.2],[1,0,0,0,0]);
% set up its own initial background value for each background function
kk = kk.set_bfun(@(x,par)(par(1)),1);

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


