function w2c = cut_plot_edep111_Ei800(en,varargin)
extract_background = false;
dE = 5;
pr = projection([1/sqrt(2),-1/sqrt(2),0],[0,0,1],[-1/sqrt(2),-1/sqrt(2),0]);
dat = fullfile(pwd,'sqw','data','Fe_ei787.sqw');
l0 = -1;
dL = [l0-0.1,l0+0.1];
bg_par = {[-8,-2.5],[-2.5,0.05,2.5],dL,[en-dE ,en+dE ]};
w2 = cut_sqw(dat,pr,[-8,0.05,2.5],[-2.5,0.05,2.5],dL,[en-dE,en+dE ]);

if extract_background
    bg = cut_sqw(dat,pr,bg_par{:});
    bgc = replicate(bg,w2);
    w2c = w2-bgc;
else
    w2c = w2; %-bgc;
end
if nargin>1
    mi = MagneticIons('Fe0');
    w2c = mi.correct_mag_ff(w2c);
    maf_ff = 0;
else
    maf_ff = 1;
end
plot(w2c);
ly -2.5 2.5
lx -2.5 2.5
if nargin > 1
    lz 0 1
else
    lz 0 0.3
end
keep_figure
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
w2c = set_sample_and_inst(w2c,sample,@maps_instrument_for_tests,'-efix',600,'S');

w2th = sqw_eval(w2c,@disp_dft_parameterized,[0.045,maf_ff]);
% kk = tobyfit(w2c);
% kk = kk.set_fun(@disp_dft_parameterized,[0.045,maf_ff],[0,0]);
% [w2th,fp_arr1]=kk.simulate;
if extract_background
    bg = cut_sqw(w2th,pr,bg_par{:});
    bgc = replicate(bg,w2th);
    w2th = w2th-bgc;
end
fh = plot(w2th);
lx -2.5 2.5
ly -2.5 2.5
if nargin > 1
    lz 0 1
else
    lz 0 0.1
end
keep_figure

d = 0.4;
sq2 = sqrt(2);
bp=gen_rf_points_110(d,[0,0; -sq2,0; sq2,0; -sq2,2; 0,2; sq2,2; -sq2,-2; 0,-2; sq2,-2]);
resolution_plot(w2c,bp,'fig',fh)

if extract_background
    dif = w2th - w2c;
    plot(dif);
    lx -2.5 2.5
    ly -2.5 2.5
    lz 0 0.3
end


