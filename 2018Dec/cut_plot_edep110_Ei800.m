function w2c = cut_plot_edep110_Ei800(en,varargin)
dE = 5;
pr = projection([1,0,0],[0,1,0]);
dat = fullfile(pwd,'sqw','data','Fe_ei787.sqw');

w2 = cut_sqw(dat,pr,[-3,0.05,3.5],[-3,0.05,8],[-0.1,0.1],[en-dE,en+dE ]);
bg = cut_sqw(dat,pr,[-3,0.05,3.5],[4,8],[-0.1,0.1],[en-dE ,en+dE ]);
bgc = replicate(bg,w2);
w2c = w2-bgc;
%w2c = w2; %-bgc;
if nargin>1
    mi = MagneticIons('Fe0');
    w2c = mi.correct_mag_ff(w2c);
    maf_ff = 0;    
else
    maf_ff = 1;
end
plot(w2c);
ly -2.5 3.5
if nargin > 1
    lz 0 1
else
    lz 0 0.1
end
keep_figure
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
w2c = set_sample_and_inst(w2c,sample,@maps_instrument_for_tests,'-efix',600,'S');

%w2th = sqw_eval(w2c,@disp_dft_parameterized,[0.045,maf_ff]);
kk = tobyfit(w2c);
kk = kk.set_fun(@disp_dft_parameterized,[0.045,maf_ff],[0,0]);
[w2th,fp_arr1]=kk.simulate;

bg = cut_sqw(w2th,pr,[-3,0.05,3.5],[4,8],[-0.1,0.1],[en-dE ,en+dE ]);
bgc = replicate(bg,w2th);
w2th = w2th-bgc;
plot(w2th);
ly -2.5 3.5
if nargin > 1
    lz 0 1
else
    lz 0 0.1
end
keep_figure
