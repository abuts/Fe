function q_cut(q,width)

mi=MagneticIons('Fe0');
%data1='d:\users\abuts\SVN\Fe\Feb2013\sqw\Fe_ei787.sqw';
data1='d:\users\abuts\SVN\Fe\Feb2013\sqw\Fe_ei401.sqw';
pr.u=[1,1,0];
pr.v=[1,-1,0];

w1=cut_sqw(data1,pr,[1-width/2,1+width/2],[q,q+width],[-width/2,width/2],[100,10,300]);
w1f=mi.fix_magnetic_ff(w1);
plot(w1f)
keep_figure
