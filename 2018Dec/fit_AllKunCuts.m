function fp_arr1 = fit_AllKunCuts()

dE   = 5;

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


w2all = cell(1,numel(proj));
w2tha = cell(1,numel(proj));
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

for i=1:numel(proj)
    w2all{i} = cut_sqw(dat,proj{i},[-2,0.05,3],Dqk ,Dql ,[0,dE,800]);
    w2all{i} = set_sample_and_inst(w2all{i},sample,@maps_instrument_for_tests,'-efix',600,'S');
    plot(w2all{i});
    keep_figure;
    ly 0 450
    lz  0 1
    w2tha{i} = sqw_eval(w2all{i},@disp_kun_calc,[1,0,kun_sym(i),kun_sym_dir(i),Kun_width]);
    w2tha{i}.data.e = ones(size(w2tha{i}.data.s));
    plot(w2tha{i});
    
    ly 0 450
    lz  0 1
end

% S(Q,w) model
ff = 1; % 1
T = 8;  % 2
%gamma = 10; % 3
gamma = 19.6424;
gap = 0;    % 5
%Seff = 2;   % 4
Seff = 0.5816;
%J1 = 40;    % 6
J0 = 49.8037;
J1 = 5.8036;
J2 = -7.0439;
J3 = -2.0729;
J4 = 1.4187;
par = [ff, T, gamma, Seff, gap, J0, J1, J2, J3, J4];

kk = tobyfit(w2all{:});
kk = kk.set_fun(@sqw_iron,par,[0,0,1,1,0,1,1,1,1,1]);
kk = kk.set_bfun(@(q,en,par)(par(1)*exp(-par(2)*(en-50))),[0.4,0.015]);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-3]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
[w2D_arr1_tf,fp_arr1]=kk.fit;
%[w2D_arr1_tf,fp_arr1]=kk.simulate;

for i=1:numel(w2D_arr1_tf)
    plot(w2D_arr1_tf{i});
    ly 0 450
    lz 0 1
    keep_figure
end

