function w2s2 = disp_GH_all_Ei1400(fix_mag_ff)
Emax = 400;
dE   = 5;
Dqh = [0.85,1.15];
Dqk = [0.85,1.15];

pr = projection([1,0,0],[0,1,0]);
dat = fullfile(pwd,'sqw','data','Fe_ei1371_base.sqw');
s_1 = symop([1,0,0], [0,0,1], [1,0,0]);
s_2 = symop([1,0,0], 90, [1,0,0]);
s_3 = symop([1,0,0], -90, [1,0,0]);
w2ss = cut_sqw_sym(dat,pr,Dqh ,Dqk ,[-3,0.05,3],[0,dE,Emax],{s_1,s_2,s_3});
w2s2 = symmetrise_sqw(w2ss,[1,0,0],[0,-1,0],[1,0,0]);

bg = cut_sqw(w2s2,pr,Dqh ,Dqk ,[2.5,3],[0,dE,Emax]);
if sum(bg.data.npix)>0
    bgc = replicate(bg,w2s2);
    %w2ssc  = w2ss;
    w2s2  = w2s2 -bgc;
else
end
if nargin>0
    mi = MagneticIons('Fe0');
    w2s2 = mi.correct_mag_ff(w2s2);
end
plot(w2s2);
lx 0 2.5
%ly -2.5 2.5

if nargin > 0
    lz 0 0.5
else
    lz 0 0.2
end
keep_figure;
%
w2th = sqw_eval(w2s2,@disp_dft_parameterized,[0.05,1]);
bgt = cut_sqw(w2th,pr,Dqh ,Dqk ,[2.5,3],[0,dE,Emax]);
bgt = replicate(bgt,w2th);
w2th = w2th-bgt;
if nargin>0
    w2th = mi.correct_mag_ff(w2th);
end
plot(w2th);
lx 0 2.5
if nargin > 0
    lz 0 10
else
    lz 0 0.2
end
keep_figure;

