mi=MagneticIons('Fe0');
%data1='d:\users\abuts\SVN\Fe\Feb2013\sqw\Fe_ei787.sqw';
data1='d:\users\abuts\SVN\Fe\Feb2013\sqw\Fe_ei401.sqw';

pr.u=[1,1,0];
pr.v=[1,-1,0];

bg=cut_sqw(data1,pr,[1-0.1,1+0.1],[-4,-3],[-0.1,0.1],[0,10,400],'-nopix');
w2=cut_sqw(data1,pr,[1-0.1,1+0.1],[-2,0.05,2],[-0.1,0.1],[0,10,400]);
bg=replicate(bg,dnd(w2));
bgf=mi.fix_magnetic_ff(bg);
w2f=mi.fix_magnetic_ff(w2); %-bgf;
plot(w2f)
lz 0 4
