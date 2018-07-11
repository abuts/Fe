[Jds2,Sds2,GamDs2]=get_Jfit('J_CenFit_Fe_ei200br_[0m11]J0-0','<100>');
[Jds4,Sds4,GamDs4]=get_Jfit('J_CenFit_Fe_ei401br_[0m11]J0-0','<100>');
acolor('r')
dd(Jds2);
acolor('g')
pd(Jds4)
ly 0 40
keep_figure;

acolor('r')
dd(Sds2);
acolor('g')
pd(Sds4)
keep_figure;

acolor('r')
dd(GamDs2);
acolor('g')
pd(GamDs4)
keep_figure;
