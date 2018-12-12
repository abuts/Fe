function w2c = cut_plot_dir100_edep_Ei800(en,varargin)
dE = 5;
h0 = 1;
dh = [h0-0.1,h0+0.1];
pr = projection([1,0,0],[0,1,0]);
dat = fullfile(pwd,'sqw','data','Fe_ei787.sqw');

w2 = cut_sqw(dat,pr,dh,[-2,0.05,8],[-3,0.05,3],[en-dE,en+dE]);
bg = cut_sqw(dat,pr,dh,[2.5,8],[-3,0.05,3],[en-dE,en+dE]);
bgc = replicate(bg,w2);
%w2c = w2-bgc;
w2c = w2; 
if nargin>1
    mi = MagneticIons('Fe0');
    w2c = mi.correct_mag_ff(w2c);
end
ph = plot(w2c);
lx -2 3
ly -2.5 2.5
if nargin > 1
    lz 0 1
else
    lz 0 0.3
end
keep_figure
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
w2c = set_sample_and_inst(w2c,sample,@maps_instrument_for_tests,'-efix',600,'S');

d = 0.4;
refp = gen_rf_points_110(d,[1,0;2,-1;2,1]);
resolution_plot(w2c,refp,'fig',ph)
