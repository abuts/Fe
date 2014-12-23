function [w1,fw1,par]=toby_twogauss(E0,dE)

% Toby's sniffing about the data  (20 Sep 2013)
% -------------------------------------------------
% % single Gaussian on linear background
% data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw';
% 
% u=[0,1,0];
% proj.type = 'ppp';
% proj.uoffset= [2,0,0,0];
% [proj.u,proj.v,proj.w]=make_ortho_set(u);
% 
% k_min=-0.5;
% k_max=0.0;
% dk=0.05;
% dkr=0.025;
% 
% E0=125;
% dE=5;
% 
% %-------------------------------------------------------------------------------
% w1=cut_sqw(data_source,proj,[k_min,dkr,k_max],[-dk,dk],[-dk,dk],[E0-dE,E0+dE]);
% 
% acolor('k')
% h=plot(w1);
% 
% % Fit1:
% IP=0.07;
% ki=-0.22;
% [fw1,par]=fit(w1,@gauss_area_bkgd,[IP,ki,0.05,0.01,0],[1,1,1,1,0]);
% acolor('r')
% pl(fw1);


% Two gaussians
% -------------

data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw';

u=[0,1,0];
proj.type = 'ppp';
proj.uoffset= [2,0,0,0];
[proj.u,proj.v,proj.w]=make_ortho_set(u);

k_min=-1;
k_max=1;
dk=0.1;
dkr=0.025;

ki=sqrt(E0/1100);   % rough dispersion in these units
w1=cut_sqw(data_source,proj,[-2.5*ki,dkr,2.5*ki],[-dk,dk],[-dk,dk],[E0-dE,E0+dE]);

acolor('k')
h=plot(w1);

% Fit1:
IP=0.07;
[fw1,par]=fit(w1,@two_gauss_area_bkgd,[IP,ki,0.05,IP,-ki,0.05,0.01,0],[1,1,1,1,1,1,1,1]);
acolor('r')
pl(fw1);

