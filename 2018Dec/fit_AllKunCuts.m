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
par = {...
    [1.0000    8.0000   25.5123    1.4809         0   50.7570   17.1764   -6.0536   -3.8352    0.4721],...
    [1.0000    8.0000   20.5648    1.0057         0   50.7570   17.1764   -6.0536   -3.8352    0.4721],...
    [1.0000    8.0000  125.3185    1.7418         0   50.7570   17.1764   -6.0536   -3.8352    0.4721],...
    [1.0000    8.0000  121.2643    2.0886         0   50.7570   17.1764   -6.0536   -3.8352    0.4721],...
    [1.0000    8.0000  243.4853    1.5223         0   50.7570   17.1764   -6.0536   -3.8352    0.4721],...
    [1.0000    8.0000  176.2602    1.5390         0   50.7570   17.1764   -6.0536   -3.8352    0.4721],...
    [1.0000    8.0000  383.9945    0.6447         0   50.7570   17.1764   -6.0536   -3.8352    0.4721],...
    [1.0000    8.0000  193.9500    1.3256         0   50.7570   17.1764   -6.0536   -3.8352    0.4721],...
    [1.0000    8.0000  301.7704    1.9788         0   50.7570   17.1764   -6.0536   -3.8352    0.4721]...
    };

bp = {...
        [0.2744    0.0151],...
    [0.3271    0.0189],...
    [0.4385    0.0183],...
    [0.3562    0.0161],...
    [0.3322    0.0134],...
    [0.3564    0.0135],...
    [0.3515    0.0191],...
    [0.3281    0.0130],...
    [0.2175    0.0175]...
    };
for i=1:numel(proj)
    w2tha{i} = sqw_eval(w2all{i},@sqw_iron,par{i});  
    plot(w2tha{i}); 
    ly 0 450    
    lz 0 0.5
    
end

kk = tobyfit(w2all{:});
%kk = kk.set_fun(@sqw_iron,par,[0,0,1,1,0,1,1,1,1,1]);
%kk = kk.set_bfun(@(q,en,par)(par(1)*exp(-par(2)*(en-50))),[0.4,0.015]);
kk = kk.set_local_foreground;
kk = kk.set_fun(@sqw_iron,par,[0,0,1,1,0,1,1,1,1,1]);
kk = kk.set_bind ({6, [6,1]},{7, [7,1]},{8, [8,1]},{9, [9,1]},{10, [10,1]});
kk = kk.set_bfun(@(q,en,par)(par(1)*exp(-par(2)*(en-50))),bp);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-3]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
[w2D_arr1_tf,fp_arr1]  =kk.fit;
%[w2D_arr1_tf,fp_arr1]=kk.simulate;

for i=1:numel(w2D_arr1_tf)
    bg_par = fp_arr1.bp{i};
    bg =func_eval(w2all{i},@(q,en,par)(par(1)*exp(-par(2)*(en-50))),bg_par);
    scat = w2all{i}-bg;
    plot(scat);
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
    lz 0 1
    hold off;
end

