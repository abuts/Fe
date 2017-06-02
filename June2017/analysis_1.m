%% --------------------------------------------------------------------------------------
% Setup
data_source=fullfile(pwd,'sqw','Data','Fe_ei787.sqw');  % sqw file from which to take cuts for setup
%data_source='d:\users\abuts\SVN\Fe\Data\sqw\Fe_ei787.sqw';  % sqw file from which to take cuts for setup

datafile='test_tobyfit_1_data.mat';   % filename where saved results are written



%% --------------------------------------------------------------------------------------
% Create cuts to save as input data
% --------------------------------------------------------------------------------------

make_data = true;

if make_data
    % Short cut along [1,1,0]
    proj.u=[1,1,0];
    proj.v=[-1,1,0];
    w110a=cut_sqw(data_source,proj,[0.95,1.05],[-0.6,0.05,0.6],[-0.05,0.05],[150,160]);
    
    % Long cut along [1,1,0]
    proj.u=[1,1,0];
    proj.v=[-1,1,0];
    w110b=cut_sqw(data_source,proj,[0.95,1.05],[-2,0.05,3],[-0.05,0.05],[150,160]);
    
    % Create cuts to simulate or fit simultaneously
    proj.u=[1,1,0];
    proj.v=[-1,1,0];
    w110_1=cut_sqw(data_source,proj,[0.95,1.05],[-0.6,0.05,0.6],[-0.05,0.05],[140,160]);
    w110_2=cut_sqw(data_source,proj,[0.95,1.05],[-0.6,0.05,0.6],[-0.05,0.05],[160,180]);
    w110_3=cut_sqw(data_source,proj,[0.95,1.05],[-0.6,0.05,0.6],[-0.05,0.05],[180,200]);
    
    w110arr=[w110_1,w110_2,w110_3];
    
else
    % Read in data
    load(datafile);
end

% Add instrument and sample information to cuts
sample = IX_sample (true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
w110a = set_sample (w110a, sample);
w110b = set_sample (w110b, sample);
w110arr = set_sample (w110arr, sample);

w110a = set_instrument (w110a,@maps_instrument,'-efix',600,'S');
w110b = set_instrument (w110b,@maps_instrument,'-efix',600,'S');
w110arr = set_instrument (w110arr,@maps_instrument,'-efix',600,'S');




%% --------------------------------------------------------------------------------------
% Fit single cut
% --------------------------------------------------------------------------------------

% Fit single cut with true cross-section
ff = 1;
T = 8;
gamma = 10;
gap = 0;
Seff = 2;
J1 = 40;
par = [ff, T, gamma, Seff, gap, J1, 0 0 0 0];

kk=tobyfit2(w110a);
kk=kk.set_fun(@sqw_iron,par,[0,0,1,1,0,1,0,0,0,0]);
kk=kk.set_bfun(@linear_bg,[0,0]);
kk=kk.set_mc_points(100);
kk = kk.set_options('listing',2);
[w110a_fit,fp110a]=kk.fit;

acolor k; dd(w110a)
acolor r; pd(w110a_fit)



%% --------------------------------------------------------------------------------------
% Fit multiple datasets
% ---------------------------------------------------------------------------------------

% S(Q,w) model
ff = 1;
T = 8;
gamma = 10;
gap = 0;
Seff = 2;
J1 = 40;
par = [ff, T, gamma, Seff, gap, J1, 0 0 0 0];

% Background (linear)
const=0;
grad=0;


% ---------------------------------------------------------------------------------------
% Global foreground; allow parameters to vary independently

kk = tobyfit2(w110arr);
kk = kk.set_fun(@sqw_iron,par,[0,0,1,1,0,1,0,0,0,0]);
kk = kk.set_bfun(@linear_bg,[const,grad],[1,1]);
kk = kk.set_mc_points(10);
kk = kk.set_options('listing',2);
[w110arr1_fit,fp110arr1]=kk.fit;

fback = kk.simulate(fp110arr1,'back');  % simulate background with fitted parameters

acolor k b r
dp(w110arr)
pl(w110arr1_fit)
pl(fback)
ly 0 0.4

% ---------------------------------------------------------------------------------------
% Local foreground; constrain SJ as global but allow amplitude and gamma to vary locally

kk = tobyfit2(w110arr);
kk = kk.set_local_foreground;
kk = kk.set_fun(@sqw_iron,par,[0,0,1,1,0,1,0,0,0,0]);
kk = kk.set_bind({6,[6,1]});
kk = kk.set_bfun(@linear_bg,[const,grad],[1,1]);
kk = kk.set_mc_points(10);
kk = kk.set_options('listing',2);
[w110arr1_fit,fp110arr1]=kk.fit;

fback = kk.simulate(fp110arr1,'back');  % simulate background with fitted parameters

acolor k b r
dp(w110arr)
pl(w110arr1_fit)
pl(fback)
ly 0 0.4



