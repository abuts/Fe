function w2c = cut_plot_edep011_Ei1400(en,varargin)

pr = projection([1,0,0],[0,1,0]);
dat = fullfile(pwd,'sqw','data','Fe_ei1371_base.sqw');

w2 = cut_sqw(dat,pr,[0.9,1.1],[-3,0.05,4],[-2,0.05,2],[en-15,en+15]);
bg = cut_sqw(dat,pr,[0.9,1.1],[3,4],[-2,0.05,2],[en-15,en+15]);
if sum(bg.data.npix)>0
    bgc = replicate(bg,w2);
    w2c = w2-bgc;
else
    w2c = w2;
end
if nargin>1
    mi = MagneticIons('Fe0');
    w2c = mi.correct_mag_ff(w2c);
end
fh = plot(w2c);
lx -2.5 2.5
ly -2.5 2.5

if nargin > 1
    lz 0 1
else
    lz 0 0.3
end

sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
w2c = set_sample_and_inst(w2c,sample,@maps_instrument_for_tests,'-efix',600,'A');

d = 0.4;
resolution_plot(w2c,[0,-1-d;0,-1+d;0,1-d;0,1+d;-1-d,0;-1+d,0;1-d,0;1+d,0],'fig',fh)
