function spher_cut200()
% Sample spherical cut
data_source= fullfile(pwd,'Data','Fe_ei200.sqw');
proj = spher_proj([2,0,0]);
mff = MagneticIons('Fe0');


cut1 = cut_sqw(data_source,proj,[0.1,0.4],[-90,1,90],2,[100,105]);
%cut = cut_sqw(data_source,proj,[0,0.01,0.6],[-90,90],[-180,180],2);
cut1 = mff.fix_magnetic_ff(cut1);
%cut1=dnd(cut1); % dnd looses projection
%smooth(cut1,16)
da(cut1)
hold on

cut2 = cut_sqw(data_source,proj,[0.1,0.4],[-90,1,90],2,[55,60]);
cut2 = mff.fix_magnetic_ff(cut2);
%cut2=dnd(cut2);
%smooth(cut2,12)
dp(cut2)