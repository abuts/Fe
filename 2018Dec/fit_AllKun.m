function fp_arr1 = fit_AllKun()

dE   = 5;

use_ff = 0;
Kun_width = 0.1;

Dqk = [-0.1,0.1];
Dql = [-0.1,0.1];
kun_sym  =    [1,1,2,3,3,5,5,4,4];
kun_sym_dir = [1,2,1,3,3,1,2,1,1];
proj = {projection([1,0,0],[0,1,0],'uoffset',[0,0,0]),projection([0,1,0],[-1,0,0],'uoffset',[0,2,0]),...
    projection([1,-1,0],[1,1,0],'uoffset',[1,1,0]),...
    projection([-1, 1,1],[1,1,0],'uoffset',[0,1,0]),projection([1,1,1],[1,-1,0],'uoffset',[0,1,0]),...
    projection([0,0,1],[0,1,0],'uoffset',[1.5,0.5,0]),projection([0,1,0],[-1,0,0],'uoffset',[-0.5,1,0.5]),...
    projection([-1,1,0],[1,1,0],'uoffset',[1,0,0]),projection([1,1,0],[1,-1,0],'uoffset',[0,1,0])};


dat = fullfile(pwd,'sqw','data','Fe_ei787.sqw');
dist = -2:0.05:3;
dir_cell = cell(numel(proj),1);
for i=1:numel(proj)
    e0 = proj{i}.uoffset(1:3)';
    dir = proj{i}.u;
    e1 = dir/sqrt(dir*dir');
    qh = e0(1)+e1(1)*dist;
    qk = e0(2)+e1(2)*dist;
    ql = e0(3)+e1(3)*dist;    
    dir_cell{i} = {qh,qk,ql};
end




w2all = cell(1,numel(proj));
w2tha = cell(1,numel(proj));
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

for i=1:numel(proj)
    w2all{i} = cut_sqw(dat,proj{i},[-2,0.05,3],Dqk ,Dql ,[0,dE,800]);
    w2all{i} = set_sample_and_inst(w2all{i},sample,@maps_instrument_for_tests,'-efix',600,'S');
    plot(w2all{i});
    ly 0 450
    lz  0 1
    w2tha{i} = sqw_eval(w2all{i},@disp_kun_calc,[1,use_ff,kun_sym(i),kun_sym_dir(i),Kun_width]);
    w2tha{i}.data.e = ones(size(w2tha{i}.data.s));
    plot(w2tha{i});
    keep_figure;
    ly 0 450
    lz  0 1
end
% Fitting results:
%      p: [0 8 0.6339 1.4573 0 51.6456 1.4097 -8.4474 -0.7469 0.6056]
%    sig: [0 0 0.0175 0.0110 0 0.0193 0.0140 0.0066 0.0053 0.0122]
% Fitting results if magnetic form factor is on
%       p: [1 8 0.1192 2.8410 0 52.5701 1.2584 -8.4104 -0.7862 0.31485]
%     sig: [0 0 8.1738e-04 0.0183 0 0.0029 0.0014 0.0014 1.7954e-04 7.8935e-04]


% S(Q,w) model
ff = use_ff; % 1
T = 8;  % 2
%gamma = 10; % 3
gamma = 0.6339; % 0.6810;
gap = 0;    %
%Seff = 2;   %
Seff = 1.4573;      %1.4489;
%J1 = 40;    % 6
J0 = 51.6456;       %51.6079;
J1 = 1.4097;         %1.4083;
J2 = -8.4474;       %-8.4407;
J3 = -0.7469;       %-0.7448;
J4 = 0.6056;        %0.6047;
par = [ff, T, gamma, Seff, gap, J0, J1, J2, J3, J4];
par = {
    [ff T   -2.0426    1.6942         0   52.3601    1.4598   -8.5227   -0.7477    0.5713],...
    [ff T    1.1685    1.9757         0   52.3601    1.4598   -8.5227   -0.7477    0.5713],...
    [ff T    1.8368    1.6197         0   52.3601    1.4598   -8.5227   -0.7477    0.5713],...
    [ff T    0.2543    3.0051         0   52.3601    1.4598   -8.5227   -0.7477    0.5713],...
    [ff T  -12.1472    1.6010         0   52.3601    1.4598   -8.5227   -0.7477    0.5713],...
    [ff T   31.1100    1.2732         0   52.3601    1.4598   -8.5227   -0.7477    0.5713],...
    [ff T   52.9839    1.9732         0   52.3601    1.4598   -8.5227   -0.7477    0.5713],...
    [ff T   19.1982    0.7865         0   52.3601    1.4598   -8.5227   -0.7477    0.5713],...
    [ff T    4.8801    0.6585         0   52.3601    1.4598   -8.5227   -0.7477    0.5713]};

kk = tobyfit(w2tha{:});
kk = kk.set_local_foreground;
kk = kk.set_fun(@sqw_iron,par,[0,0,1,1,0,1,1,1,1,1]);
kk = kk.set_bind ({6, [6,1]},{7, [7,1]},{8, [8,1]},{9, [9,1]},{10, [10,1]});

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',2,'fit_control_parameters',[1.e-2;60;1.e-3]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
%[w2D_arr1_tf,fp_arr1]=kk.fit;
[w2D_arr1_tf,fp_arr1]=kk.simulate;

for i=1:numel(w2D_arr1_tf)
    plot(w2tha{i});
    keep_figure;    
    par= fp_arr1.p{i};
    q_dir = dir_cell{i};
    hold on;
    disp = disp_bcc_hfm(q_dir{:},par(4:10));
    e1 = proj{i}.u;
    norm = sqrt(e1*e1');
    %d_l = dist+sqrt(e0*e0');
    d_l = dist/norm;
    plot(d_l,disp{1},'r');
    gp = disp{1}+abs(par(3));    
    gm = disp{1}-abs(par(3));
    plot(d_l,gp,'m.');    
    plot(d_l,gm,'m.');        
    ly 0 450    
    hold off;
end

