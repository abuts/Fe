%% --------------------------------------------------------------------------------------
% Setup
root = 'd:\users\abuts\SVN\Fe';

ds8=fullfile(root,'Data','sqw','Fe_ei787.sqw');  % sqw file from which to take cuts for setup
ds4=fullfile(root,'Data','sqw','Fe_ei401.sqw');  % sqw file from which to take cuts for setup
ds2=fullfile(root,'Data','sqw','Fe_ei200.sqw');  % sqw file from which to take cuts for setup
%data_source='d:\users\abuts\SVN\Fe\Data\sqw\Fe_ei787.sqw';  % sqw file from which to take cuts for setup

%datafile='test_tobyfit_1_data.mat';   % filename where saved results are written
proj.u=[1,1,0];
proj.v=[-1,1,0];
w3=cut_sqw(ds8,proj,[-2,0.05,2],[-2,0.05,2],[-0.2,0.2],[0,10,400]);
plot(w3)

proj.u=[1,0,0];
proj.v=[0,1,0];
w2 = cut_sqw(ds8,proj,[-2,0.05,2],[-2,0.05,2],[-0.2,0.2],[140,160]);
plot(w2)
keep_figure
%----------------------------------------------------------------
proj.u=[1,1,0];
proj.v=[-1,1,0];
w2 = cut_sqw(ds8,proj,[0.8,1.2],[-2,0.05,3],[-0.2,0.2],[0,10,400]);
plot(w2)
t_bg = cut_sqw(w2,proj,[0.8,1.2],[2,3],[-0.2,0.2],[0,10,400]);
w_bg = replicate(t_bg,w2);
w2 = w2-w_bg;
plot(w2)
keep_figure
ff = MagneticIons('Fe0');
w2 = ff.correct_mag_ff(w2);
plot(w2)
lz 0. 0.5
lx -2 2

keep_figure
proj.u=[-1,1,1];
proj.v=[1,1,0];
proj.uoffset=[2,0,0];
w2=cut_sqw(ds8,proj,[-2,0.05,3],[-2,0.05,3],[-0.15,0.15],[140,150]);
plot(w2)
w2=cut_sqw(ds8,proj,[-0.15,0.15],[-1,0.05,1],[-0.15,0.15],10);
plot(w2)
w2_100a=cut_sqw(ds8,proj,[-1,0.05,1],[-1,0.05,1],[-0.15,0.15],[190,200]);
plot(w2_100a)
lz 0 0.5
keep_figure
w2_100b=cut_sqw(ds8,proj,[-1,0.05,1],[-1,0.05,1],[-0.15,0.15],[200,210]);
plot(w2_100b)
lz 0 0.5
keep_figure
w2_100c=cut_sqw(ds8,proj,[-1,0.05,1],[-1,0.05,1],[-0.15,0.15],[210,220]);
plot(w2_100c)
lz 0 0.5
keep_figure

w2_100b=cut_sqw(ds4,proj,[1,0.05,3],[-0.15,0.15],[-0.15,0.15],[0,5,400]);
plot(w2_100b)
keep_figure
w2_100c=cut_sqw(ds2,proj,[1,0.05,3],[-0.15,0.15],[-0.15,0.15],[0,2,400]);
plot(w2_100c)
keep_figure


w2=cut_sqw(ds8,proj,[-2,0.05,3],[-2,0.05,3],[-0.15,0.15],[200,220]);
plot(w2)

proj.u=[1,0,0];
proj.v=[0,1,0];
w2=cut_sqw(ds8,proj,[-2,0.05,3],[-2,0.05,3],[-0.15,0.15],[140,150]);
plot(w2)


proj.u=[1,0,0];
proj.v=[0,1,0];
if isfield(proj,'uoffset')
    proj = rmfield(proj,'uoffset');
end
w2=cut_sqw(ds2,proj,[0,0.025,2],[-1.05,-0.95],[-0.05,0.05],[0,1,140]);
plot(w2)

proj.u=[1,0,0];
proj.v=[0,1,0];
%w100=cut_sqw(ds2,proj,0.025,0.025,[-0.05,0.05],[100,105]);
w100=cut_sqw(ds8,proj,0.05,[-0.15,0.15],[-0.15,0.15],5);
plot(w100)

proj.u=[1,0,0];
proj.v=[0,1,0];
wle=cut_sqw(ds2,proj,[-2,0.05,2],[0.95,1.05],[-0.2,0.2],[0,2,200]);
plot(wle)
proj.u=[1,1,0];
proj.v=[-1,1,0];
wle=cut_sqw(ds2,proj,[-2,0.05,2],[0.95,1.05],[-0.2,0.2],[0,2,200]);
lx 0 1.5
ly 0 100
plot(wle)
proj.u=[1,1,1];
proj.v=[-1,1,1];
proj.uoffset = [1,1,0];
wle=cut_sqw(ds2,proj,[-2,0.05,2],[-0.05,.05],[-0.1,0.1],[0,2,200]);
lx -0.5 0.5
ly 0 100
plot(wle)



bp = [0,0,0;1,0,0;0.5,0.5,0;0,0,0;1/2,1/2,1/2;1/2,1/2,0];
bp1 = [1,-1,0;2,-1,0;0.5,0.5,0;0,0,0;1/2,1/2,1/2;1/2,1/2,0];

wsp = spaghetti_plot(bp,ds4,'labels',{'\Gamma','H','N','\Gamma','P','N'});

fj200 = IX_dataset_1d('Effective total exchange interaction energy',...
    ld.fj200.signal,ld.fj200.error,'J0 (mEv)',...
    ld.fj200.x,' Energy transfer (mEv)',false);
fj400 = IX_dataset_1d('Effective total exchange interaction energy',...
    ld.fj400.signal,ld.fj400.error,'J0 (mEv)',...
    ld.fj400.x,' Energy transfer (mEv)',false);

acolor('r')
[~,~,l1]=dd(fj400);
acolor('b')
[~,~,l2]=pd(fj200);
ly 0 40
ly 20 40
lx 20 200
%legend([l1;l2],'Ei400 mEv','Ei200 mEv')


