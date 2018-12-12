function w2c = cut_plot_edep_Ei800(en,varargin)
dE = 5;
dl = [-0.1,0.1];
pr = projection([1,0,0],[0,1,0]);
dat = fullfile(pwd,'sqw','data','Fe_ei787.sqw');

w2 = cut_sqw(dat,pr,[-3,0.05,3.5],[-3,0.05,8],dl,[en-dE,en+dE]);
bg = cut_sqw(dat,pr,[-3,0.05,3.5],[4,8],dl,[en-dE,en+dE]);
bgc = replicate(bg,w2);
w2c = w2-bgc;
if nargin>1
    mi = MagneticIons('Fe0');
    w2c = mi.correct_mag_ff(w2c);
end
plot(w2c);
ly -2.5 3.5
if nargin > 1
    lz 0 1
else
    lz 0 0.3
end
keep_figure
dl = [-1.1,-0.9];
w2 = cut_sqw(dat,pr,[-3,0.05,3.5],[-3,0.05,8],dl,[en-dE,en+dE]);
bg = cut_sqw(dat,pr,[-3,0.05,3.5],[4,8],[-0.1,0.1],[en-dE,en+dE]);
bgc = replicate(bg,w2);
w2c = w2-bgc;
if nargin>1
    mi = MagneticIons('Fe0');
    w2c = mi.correct_mag_ff(w2c);
end
plot(w2c);
ly -2.5 3.5
if nargin > 1
    lz 0 1
else
    lz 0 0.3
end
keep_figure
dl = [0.9,1.1];
w2 = cut_sqw(dat,pr,[-3,0.05,3.5],[-3,0.05,8],dl,[en-dE,en+dE]);
bg = cut_sqw(dat,pr,[-3,0.05,3.5],[4,8],[-0.1,0.1],[en-dE,en+dE]);
bgc = replicate(bg,w2);
w2c = w2-bgc;
if nargin>1
    mi = MagneticIons('Fe0');
    w2c = mi.correct_mag_ff(w2c);
end
plot(w2c);
ly -2.5 3.5
if nargin > 1
    lz 0 1
else
    lz 0 0.3
end
keep_figure
