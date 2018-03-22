ff = 1; % 1
T = 8;  % 2
gamma = 10; % 3
Seff = 2;   % 4
gap = 0;    % 5
J0 = 34;    % 6
J1 = 0;
J2 = 0;
par = [ff, T, gamma, Seff, gap, J0, J1, J2, 0, 0];
pfree = [0,0,1,1,0,1,0,0,0,0];

nog = tobyfit2(ww);
nog = nog.set_fun(@sqw_iron, par, pfree);
nog = nog.set_bfun(@linear_bg,[0.25,0],[1,1]);
nog = nog.set_mc_points(10);
nog = nog.set_options('list',2);
[wfit,fitdata]=nog.fit;


