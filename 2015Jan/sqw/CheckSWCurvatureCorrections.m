data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw';

pic_loc = pic_spread();
u   = [0,1,0];
bragg=[1,-1,0];
dk  = 0.05;
dE = 2;
E0 = 35;
E_max=95;
w2=make_fitting_cut( data_source,dk,dE,bragg,u);
h1=plot(w2);
pic_loc = pic_loc.set_picture(h1);

lz 0 2;

[proj.u,proj.v,proj.w]=make_ortho_set(u);
proj.type = 'ppp';
proj.uoffset= [bragg,0]';

k_min = 0;
k_middle = 0.1625;
k_max = 0.3875;
w1=cut_sqw(w2,proj,[k_min,0.5*dk,k_max],[-dk,dk],[-dk,dk],[E0,E0+2*dE]);
acolor('k')
h1=plot(w1);
pic_loc = pic_loc.set_picture(h1);

w0=cut_sqw(w2,proj,[k_middle-dk,k_middle+dk],[-dk,dk],[-dk,dk],[E0,E0+dE]);
IP=w0.data.s;

[fw1,par]=fit(w1,@gauss_bkgd,[IP,k_middle,0.2,0.01,0],[1,1,1,1,1]);
acolor('r')
pd(fw1);

sigma=abs(par.p(3));
I_tr = par.p(1)*sigma*sqrt(2*pi);

w1=cut_sqw(w2,proj,[k_middle-dk,k_middle+dk],[-dk,dk],[-dk,dk],[23,1,60]);
acolor('k')
h1=plot(w1);
pic_loc = pic_loc.set_picture(h1);
[fw1,parT]=fit(w1,@gauss_bkgd,[IP,E0,0.2,0.01,0],[1,1,1,1,1]);
acolor('r')
pd(fw1);
sigma1=abs(parT.p(3));
I_v = parT.p(1)*sigma1*sqrt(2*pi);


