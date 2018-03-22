data_source= fullfile('d:\users\abuts\SVN\Fe\Feb2013\sqw','Fe_ei200.sqw');
prj=spher_proj([2,0,0]);
en = [50,60];
dr = [0.1,0.35];
%en = [100,110];
%dr = [0.2,0.45];

mf = MagneticIons('Fe0');
cut = cut_sqw(data_source,prj,[0.1,0.01,0.5],[-90,2,90],[-180,4,180],en);
cut = mf.fix_magnetic_ff(cut);
plot(cut)