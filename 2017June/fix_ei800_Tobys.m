%--------------------------------------------------------------------------
% Reorient the crystal for the ei=787 meV data
%
% Checked and run again: 10 July 2018:
%   Does not have refined moderator parameters
%
%--------------------------------------------------------------------------

% Set up locations of data sources

data800=fullfile(pwd,'sqw','Data','Fe_ei787.sqw');

% Clear all exist proj:
tmp = whos('proj*'); for i=1:numel(tmp), clear(tmp(i).name), end


%% =================================================================================
% Constant energy slices to find good cuts to reorient the crystal
% ==================================================================================

proj.u = [1,0,0];
proj.v = [0,1,0];

w2_hk0 = cut_sqw (data800, proj, 0.05,0.05, [-0.1,0.1], [110,140], '-nopix');
plot(w2_hk0)
lx -3 3; ly -3 3; lz 0 0.5
keep_figure

w2_hk1 = cut_sqw (data800, proj, 0.1,0.1, [0.9,1.1], [110,140], '-nopix');
plot(w2_hk1)
lx -2 2; ly -2 2; lz 0 0.5
keep_figure

w2_hkm1 = cut_sqw (data800, proj, 0.05,0.05, [-1.1,-0.9], [110,140], '-nopix');
plot(w2_hkm1)
lx -2 3; ly -2 2; lz 0 0.5
keep_figure


%% Now take 1D cuts
dhh = 0.02;
dh = 0.03;
qhh_range = [-0.07,0.07];
qh_range = [-0.1,0.1];

dhh2 = 0.02;
dh2 = 0.03;
qhh2_range = [-0.1,0.1];
qh2_range = [-0.15,0.15];

e_range = [110,130];


% Through [1,-1,0] Bragg point
% ----------------------------
proj_1m10.uoffset = [1,-1,0];
proj_1m10.u = [1,0,0];
proj_1m10.v = [0,1,0];

% w_1m10_rad   = cut_sqw (data800, proj_1m10, [-1,dh,1], qh_range, qh_range, e_range);
% plot(w_1m10_rad)
% pause(1)

w_1m10_trans = cut_sqw (data800, proj_1m10, qh_range, [-1,dh,1], qh_range, e_range);
plot(w_1m10_trans)   % remove 0.5 to 0.9
pause(1)

w_1m10_vert  = cut_sqw (data800, proj_1m10, qh_range, qh_range, [-1,dh,1], e_range);
plot(w_1m10_vert)
pause(1)


% Through [-1,1,0] Bragg point
% -----------------------------
proj_m110.uoffset = [-1,1,0];
proj_m110.u = [1,0,0];
proj_m110.v = [0,1,0];

% w_m110_rad   = cut_sqw (data800, proj_m110, qh_range, [-1,dh,1], qh_range, e_range);
% plot(w_m110_rad)
% pause(1)

w_m110_trans = cut_sqw (data800, proj_m110, [-1,dh,1], qh_range, qh_range, e_range);
plot(w_m110_trans)   % remove 0.5 to 0.9
pause(1)

w_m110_vert  = cut_sqw (data800, proj_m110, qh_range, qh_range, [-1,dh,1], e_range);
plot(w_m110_vert)
pause(1)


% Through [2,0,0] Bragg point
% ----------------------------
proj_200.uoffset = [2,0,0];
proj_200.u = [1,0,0];
proj_200.v = [0,1,0];

w_200_rad   = cut_sqw (data800, proj_200, [-1,dh2,1], qh2_range, qh2_range, e_range);
plot(w_200_rad)
pause(1)

w_200_trans = cut_sqw (data800, proj_200, qh2_range, [-1,dh2,0.6], qh2_range, e_range);
plot(w_200_trans)   % remove 0.6 onwards
pause(1)

w_200_vert  = cut_sqw (data800, proj_200, qh2_range, qh2_range, [-1,dh,1], e_range);
plot(w_200_vert)
pause(1)




% Through [0,2,0] Bragg point
% ----------------------------
proj_020.uoffset = [0,2,0];
proj_020.u = [0,1,0];
proj_020.v = [1,0,0];

w_020_rad   = cut_sqw (data800, proj_020, [-1,dh2,1], qh2_range, qh2_range, e_range);
plot(w_020_rad)
pause(1)

w_020_trans = cut_sqw (data800, proj_020, qh2_range, [-1,dh2,0.6], qh2_range, e_range);
plot(w_020_trans)   % remove 0.6 onwards
pause(1)

w_020_vert  = cut_sqw (data800, proj_020, qh2_range, qh2_range, [-1,dh,1], e_range);
plot(w_020_vert)
pause(1)



%% =================================================================================
% Fit the cuts
% ==================================================================================

gam0 = 10;
Seff = 0.7;
J0 = 25;
J1 = 0;
par = [1,8,gam0,Seff,0,J0,J1,0,0,0];
free= [0,0,1,   1,   0,1 ,0 ,0,0,0];

win = [w_200_rad, w_200_trans, w_200_vert,...
    w_020_rad, w_020_trans, w_020_vert,...
    w_1m10_trans, w_1m10_vert,...
    w_m110_trans, w_m110_vert];


sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
for i = 1:numel(win)
    win(i) = set_sample_and_inst(win(i),sample,@maps_instrument_for_tests,'-efix',600,'S');
end

kk = tobyfit (win);
kk = kk.set_fun (@sqw_iron,par,free);
kk = kk.set_bfun (@linear_bg,[0.15,0]);
kk = kk.set_mc_points (10);

% Simulate
% --------
wsim = kk.simulate('comp');
for i=1:numel(win)
    plot(win(i))
    pl(wsim.sum(i))
    pl(wsim.back(i))
    pause(1)
end

% Fit
% ----
kk = kk.set_refine_crystal ('fix_angdeg','fix_alatt_ratio');
kk = kk.set_options ('list',2);
[wout,fitdata,ok,mess,rlu_corr] = kk.fit('comp');

for i=1:numel(win)
    acolor k
    plot(win(i))
    acolor r
    pl(wout.sum(i))
    pl(wout.back(i))
    pause(3)
end

% From refinement of original sqw file: (Alex copy, unaligned)
% Refiuned lattice parameter: 2.842  Angstroms
% Refined rotation vector (deg): < 1 degree
% rlu_corr =
%
%     0.9977   -0.0123   -0.0042
%     0.0123    0.9977   -0.0039
%     0.0043    0.0038    0.9978



%% See what happens if allow Seff, J and gamma to vary individually for each fit ?
% J varies from 32 to 40; gamma from 38 to 145
% Big range.
%
% Refined rotation vector (deg):  -0.1913    0.3029   -0.7129
% rlu_corr =
%     0.9984   -0.0124   -0.0053
%     0.0124    0.9984   -0.0034
%     0.0053    0.0033    0.9985


kk2 = tobyfit (win);
kk2 = kk2.set_local_foreground;
kk2 = kk2.set_fun (@sqw_iron,par,free);
kk2 = kk2.set_bfun (@linear_bg,[0.15,0]);
kk2 = kk2.set_mc_points (10);
kk2 = kk2.set_refine_crystal ('fix_angdeg','fix_alatt_ratio');
kk2 = kk2.set_options ('list',2);
[wout,fitdata,ok,mess,rlu_corr] = kk2.fit('comp');

for i=1:numel(win)
    acolor k
    plot(win(i))
    acolor r
    pl(wout.sum(i))
    pl(wout.back(i))
    pause(1)
end


% Change orientation:
% 10 July 2018: rlu_corr is almost the identity, as run once before, but still
% apply the change, to get definitive data.
change_crystal_horace (data800, rlu_corr)

