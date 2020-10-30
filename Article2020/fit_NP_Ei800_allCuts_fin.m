function [ampl,bg] = fit_NP_Ei800_allCuts_fin()

data = fullfile(fileparts(fileparts(mfilename('fullpath'))),'Data','sqw','Fe_ei787.sqw');
bg_types = containers.Map({'cut_at_edges',... % bg=[0.468004 0.015127]
    'average_cut',...
    'remote_cut'... %bad
    },{{@bg_calc_fun1,[0.468004 0.015127]},...
    {@bg_calc_fun2,[0.437546 0.014128]},...
    {@bg_calc_fun_avrg,[0.528612 0.016190]}});

Emax = 500;
dE   = 5;
Efit_min = 50;
Kun_width = 0.1;
kun_sym = 5;

Dqk = [-0.1,0.1];
Dql = [-0.1,0.1];
eval_background = false;
background_type =  'average_cut';
% view linear background substraction graphs for all cuts
view_background = false;
% view simulated model
view_model = false;
% fit cuts with Kun model and find fitting parameters for kun model
% (amplitude only). This does not work well
find_model_amplitude = false;


% proj = {projection([0,0,1],[0,1,0],'uoffset',[1.5,0.5,0]),projection([0,0,1],[0,1,0],'uoffset',[1.5,-0.5,0]),...
%     projection([0,0,1],[0,1,0],'uoffset',[0.5,1.5,0]),projection([0,0,1],[0,1,0],'uoffset',[-0.5,1.5,0]),...
%     projection([1,0,0],[0,1,0],'uoffset',[1,-0.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[1,-0.5,-0.5]),...
%     projection([1,0,0],[0,1,0],'uoffset',[1,0.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[1,0.5,-0.5]),...
%     projection([0,1,0],[-1,0,0],'uoffset',[ 0.5,1,0.5]),projection([0,1,0],[-1,0,0],'uoffset',[0.5,1,-0.5]),...
%     projection([0,1,0],[-1,0,0],'uoffset',[-0.5,1,0.5]),projection([0,1,0],[-1,0,0],'uoffset',[-0.5,1,-0.5])...
%     };
% kun_sym_dir = [1,1,1,1,3,3,3,3,2,2,2,2];
%
% Projections
% proj = {projection([1,0,0],[0,1,0],'uoffset',[1,1.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[1,1.5,-0.5]),...    %1.8708
%     projection([0,1,0],[1,0,0],'uoffset',[1.5,1 ,0.5]),projection([0,1,0],[1,0,0],'uoffset',[1.5,1 ,-0.5]),...        %1.8708
%     projection([0,0,1],[0,1,0],'uoffset',[1.5,-0.5,-0.5]) ,projection([0,0,1],[0,1,0],'uoffset',[1.5,-0.5,-0.5]) ,...
%     projection([0,1,0],[1,0,0],'uoffset',[1.5,-0.5,0.5]) ,projection([0,1,0],[1,0,0],'uoffset',[1.5,-0.5,-0.5]),...  %1.6583
%     projection([1,0,0],[0,1,0],'uoffset',[-0.5,1.5,-0.5]),projection([1,0,0],[0,1,0],'uoffset',[-0.5,1.5,0.5]),...   %1.6583
%     projection([0,0,1],[0,1,0],'uoffset',[1.5,1.5,0])}; %2.1213
% kun_sym_dir = [3,3,2,2, 1,1,2,2,3,3, 1];

% projections at d = 2.55
proj = {projection([0,1,0],[1,0,0],'uoffset',[2.5,-0.5,0.5]),projection([0,1,0],[1,0,0],'uoffset',[2.5,-0.5,-0.5]),...
    projection([1,0,0],[0,1,0],'uoffset',[-0.5,2.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[-0.5,2.5,-0.5]),...
    projection([0,0,1],[0,1,0],'uoffset',[2.5,-0.5,-0.5]),projection([0,0,1],[0,1,0],'uoffset',[2.5,0.5,-0.5]),...
    projection([0,0,1],[0,1,0],'uoffset',[-0.5,2.5,-0.5]),projection([0,0,1],[0,1,0],'uoffset',[0.5,2.5,-0.5])};
% kun_sym_dir = [2,2,3,3,1,1,1,1]; % this is the old parameters used with
% expansion 2-D calculations onto whole volume

w2e_base = cut_sqw(data,struct('u',[1,0,0],'v',[0,1,0]),[-2,0.05,4],[-3,0.05,4] ,Dql ,[350-dE,350+dE]);
liny
plot(w2e_base);
keep_figure
hold on
cut_axis = zeros(numel(proj),2);
for i=1:numel(proj)
    cut_axis(i,1) = proj{i}.uoffset(1);
    cut_axis(i,2) = proj{i}.uoffset(2);
end
scatter(cut_axis(:,1),cut_axis(:,2),'r')
hold off
% background function
bg_fun = @(en,par)(par(1)*exp(-par(2)*(en-50)));




sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
bg = bg_types(background_type);
if eval_background
    bgf = bg{1};
    bg_param = bgf(data,Dqk ,Dql,dE,bg_fun);
    fprintf(' Estimated background: [%f %f]\n',bg_param)
else
    % buckground estimated for first sequence of cuts (along h or k)
    %bg_param = [0.3779 0.0129];
    % buckground estimated for second sequence of cuts (along l)
    bg_param = bg{2};
end

% select only some projections
take_proj = 1:8;
proj_s = proj(take_proj);

w2all = cell(1,numel(proj_s ));
w2tha = cell(1,numel(proj_s ));
if find_model_amplitude
    bg_par_loc = cell(1,numel(proj_s ));
end
for i=1:numel(proj_s )
    w2all{i} = cut_sqw(data,proj_s {i},[-2,0.05,3],Dqk ,Dql ,[0,dE,Emax]);
    w2all{i} = set_sample_and_inst(w2all{i},sample,@maps_instrument,'-efix',600,'S');
    liny
    plot(w2all{i});
    bg = func_eval(w2all{i},@(q,en,par)(par(1)*exp(-par(2)*(en-50))),bg_param);
    disp = w2all{i}-bg;
    plot(disp);
    keep_figure
    liny
    
    ly 0 500
    lz  0 0.02
    
    %
    if view_background
        bg_real1D = cut_sqw(w2all{i},proj_s{i},[-2,3],Dqk ,Dql ,[0,dE,Emax]);
        bg_eval1D = func_eval(bg_real1D,bg_fun,bg_param);
        acolor('k');
        plot(bg_real1D)
        acolor('r')
        pl(bg_eval1D)
        logy
        keep_figure;
    end
    %
    
    if view_model
        liny
        w2tha{i} = sqw_eval(w2all{i},@disp_dft_param_Kun,[1,1]);
        plot(w2tha{i});
        
        ly 0 500
        lz  0 0.2
        kk = tobyfit(w2all{i});
        kk = kk.set_fun(@disp_dft_param_Kun,[0.2546,0],[1,1]);
        kk = kk.set_bfun(@(q,en,par)(par(1)*exp(-par(2)*(en-50))),bg_param);
        w2D_rc=kk.simulate;
        plot(w2D_rc);
        ly 0 500
        lz  0 0.2
        
        keep_figure
    end
    % find local background for every local cut
    if find_model_amplitude
        w2tha{i} = cut_sqw(w2all{i},proj_s{i},[-2,0.05,3],Dqk ,Dql ,[50,dE,Emax]);
        w1_bg = cut_sqw(w2all{i},proj_s{i},[-2,3],Dqk ,Dql ,[50,dE,210]);
        acolor('k');
        plot(w2tha{i})
        ft = multifit(w1_bg );
        ft = ft.set_fun(bg_fun);
        ft = ft.set_pin(bg_param);
        [fit_fun,fit_con]= ft.fit();
        bg_par_loc{i} = fit_con.p;
        acolor('r');
        pl(fit_fun);
        bg = func_eval(w2tha{i},@(q,en,par)(par(1)*exp(-par(2)*(en-50))),...
            bg_par_loc{i});
        w2tha{i}= w2tha{i}-bg;
        plot(w2tha{i})
    end
end
% sum cuts to plot the part of the dispersion in  NP direction
alpha2 = 2*atand(1/5); % the angle
sym_op = {symop([0,0,1],90),symop([0,0,1],alpha2),symop([0,0,1],90+alpha2 )};
[com_cut,part_cuts] = cut_sqw_sym(data,proj{5},[-2,0.05,3],Dqk ,Dql ,[0,dE,Emax],sym_op);
% does not work. Bug in symcut?
com_c1 = cut_sqw(com_cut,proj{5},[-2,3],Dqk ,Dql ,[0,dE,Emax]);
%com_c1 = cut_sqw_sym(data,proj{5},[-2,3],Dqk ,Dql ,[0,dE,Emax],sym_op);
bg_eval1D = func_eval(com_c1,bg_fun,bg_param);
acolor('k');
plot(com_c1)
acolor('r')
pl(bg_eval1D)
logy
keep_figure;
bg = func_eval(com_cut,@(q,en,par)(par(1)*exp(-par(2)*(en-50))),bg_param);
dis_cut = com_cut -bg;
plot(dis_cut)
liny
keep_figure;
ly 0 500
lz  0 0.02
mff = MagneticIons('Fe0');
wf = mff.correct_mag_ff(dis_cut);
plot(wf)
keep_figure;
lz 0 0.5
%
if ~find_model_amplitude
    return;
end
% fit the intensity of Kun's model

fit_fun = cell(1,numel(w2all));
for i=1:numel(w2all)
    fit_fun{i} = @(h,k,l,en,par)(disp_dft_param_Kun(h,k,l,en,par)+...
        (bg_par_loc{i}(1)*exp(-bg_par_loc{i}(2)*(en-50))));
end


kk = tobyfit(w2tha{:});
kk = kk.set_fun(@disp_dft_param_Kun,[0.2546,1],[1,0]);
%kk = kk.set_bfun(@(q,en,par)(par(1)*exp(-par(2)*(en-50))),bg_par_loc);
%
kk = kk.set_mc_points(10);
% %profile on;
kk = kk.set_options('listing',2,'fit_control_parameters',[1.e-2;60;1.e-3]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
% %profile on;
%[w2D_arr1_tf,fp_arr]=kk.simulate;
[w2D_arr1_tf,fp_arr]=kk.fit;
if iscell(w2D_arr1_tf)
    plot(w2D_arr1_tf{1})
    for i=2:numel(w2D_arr1_tf)
        plot(w2D_arr1_tf{i})
        pause(2);
    end
else
end
if iscell(fp_arr.p)
    ampl=cellfun(@(x)(x(1)),fp_arr.p,'UniformOutput',true);
    ampl = sum(ampl)/numel(ampl);
else
    ampl =fp_arr.p(1);
end

keep_figure




% %ly -2.5 2.5
% en = Efit_min:dE:Emax;
% nfp = numel(en);
% sv_ampl = NaN*zeros(1,numel(en));
% fit_err = NaN*zeros(1,numel(en));
% bg_fit   = NaN*zeros(1,numel(en));
% bg_err   = NaN*zeros(1,numel(en));
% bg_par = struct();
% n_plots = numel(proj);
% bg_par.all_bg = NaN*zeros(numel(en),n_plots);
% bg_par.all_bge = NaN*zeros(numel(en),n_plots);
% bg_par.en = NaN*zeros(numel(en),1);
%
%
% fgs = fig_spread('-tight');
% for i=1:nfp
%     cut2fit = cell(1,numel(proj));
%     for j=1:numel(proj)
%         cut2fit{j}  = cut_sqw(w2all{j},proj{j},[-3,0.02,3],Dqk ,Dql,[en(i)-dE,en(i)+dE]);
%         if isempty(cut2fit{j}.data.pix)
%             cut2fit{j} = [];
%         end
%     end
%     valid = cellfun(@(ds)(isa(ds,'sqw')),cut2fit);
%     if ~any(valid)
%         break;
%     else
%         cut2fit = cut2fit(valid);
%         kun_sym_sel = kun_sym_dir(valid);
%     end
%
%     [A,err,bg_val,bg_er,fgs,bp,bpsig]=fit_encut2(cut2fit,fgs,kun_sym,kun_sym_sel,Kun_width);
%     sv_ampl(i) = A;
%     fit_err(i) = err;
%     bg_fit(i) = bg_val;
%     bg_err(i) = bg_er;
%     %
%     bg_par.en(i) = en(i);
%     bg_par.all_bg(i,valid)  = bp;
%     bg_par.all_bge(i,valid) = bpsig;
%
%     save('bg_model_data_PN','bg_par');
% end
% acolor('b')
% errorbar(en,sv_ampl,fit_err)
% hold on
% acolor('r')
% errorbar(en,bg_fit,bg_err)
% %
% ampl = IX_dataset_1d(en,sv_ampl,fit_err);
% acolor('b')
% figure;
% pd(ampl);
% acolor('r')
% bg = IX_dataset_1d(en,bg_fit,bg_err);
% pd(bg);



function     bg_param = bg_calc_fun1(data,Dqk ,Dql,dE,bg_fun)
% evaluate background by cutting the edges of l-cuts
bg_param0 = [0.3779 0.0129];
bg_proj = projection([0,0,1],[0,1,0],'uoffset',[0.5,2.5,-0.5]);
bg_set1 = cut_sqw(data,bg_proj,[-2,0.05,3],Dqk ,Dql ,[0,dE,600]);
plot(bg_set1);
bg_set1a = cut_sqw(bg_set1,bg_proj,[-2,-1.5],Dqk ,Dql ,[50,dE,210]);
bg_set1b = cut_sqw(bg_set1,bg_proj,[2.5,3],Dqk ,Dql ,[50,dE,210]);
acolor('k')
plot(bg_set1a);
pp(bg_set1b);

bg_proj = projection([0,0,1],[0,1,0],'uoffset',[-0.5,2.5,-0.5]);
bg_set2 = cut_sqw(data,bg_proj,[-2,0.05,3],Dqk ,Dql ,[0,dE,600]);
bg_set2a = cut_sqw(bg_set2,bg_proj,[-2,-1.5],Dqk ,Dql ,[50,dE,210]);
bg_set2b = cut_sqw(bg_set2,bg_proj,[2.5,3],Dqk ,Dql ,[50,dE,210]);

acolor('b')
pp(bg_set2a);
pp(bg_set2b);
logy
ft = multifit(bg_set1a,bg_set1b,bg_set2a,bg_set2b);
ft = ft.set_fun(bg_fun);
ft = ft.set_pin(bg_param0);
[fit_fun,fit_con]= ft.fit();
bg_param = fit_con.p;
acolor('r');
pl(fit_fun{1});
keep_figure;

function     bg_param = bg_calc_fun_avrg(data,Dqk ,Dql,dE,bg_fun)
% evaluate background by averaging over a cut
bg_param0 = [0.3779 0.0129];
bg_proj = projection([0,0,1],[0,1,0],'uoffset',[0.5,4.5,-0.5]);
bg_set = cut_sqw(data,bg_proj,[-1,0.05,2],Dqk ,Dql ,[0,dE,650]);
plot(bg_set);
bg_set1 = cut_sqw(bg_set,bg_proj,[0,1],Dqk ,Dql ,[0,dE,600]);
acolor('k')
plot(bg_set1);
bg_set1a = cut_sqw(bg_set,bg_proj,[-2,3],Dqk ,Dql ,[35,dE,210]);
logy

ft = multifit(bg_set1a);
ft = ft.set_fun(bg_fun);
ft = ft.set_pin(bg_param0);
[fit_fun,fit_con]= ft.fit();
bg_param = fit_con.p;
acolor('r');
pl(fit_fun);
keep_figure;

function     bg_param = bg_calc_fun2(data,Dqk ,Dql,dE,bg_fun)
% evaluate background by cutting the edges of l-cuts
bg_param0 = [0.3779 0.0129];
bg_proj = projection([0,0,1],[0,1,0],'uoffset',[0.5,2.5,-0.5]);
bg_set1 = cut_sqw(data,bg_proj,[-2,0.05,3],Dqk ,Dql ,[0,dE,600]);
plot(bg_set1);
bg_set1 = cut_sqw(data,bg_proj,[-2,3],Dqk ,Dql ,[0,dE,600]);
acolor('k')
plot(bg_set1);
bg_set1a = cut_sqw(bg_set1,bg_proj,[-2,3],Dqk ,Dql ,[35,dE,230]);

bg_proj = projection([0,0,1],[0,1,0],'uoffset',[-0.5,2.5,-0.5]);
bg_set2 = cut_sqw(data,bg_proj,[-2,3],Dqk ,Dql ,[0,dE,600]);
acolor('b')
pp(bg_set2);
bg_set2a = cut_sqw(data,bg_proj,[-2,3],Dqk ,Dql ,[35,dE,230]);

logy
ft = multifit(bg_set1a,bg_set2a);
ft = ft.set_fun(bg_fun);
ft = ft.set_pin(bg_param0);
[fit_fun,fit_con]= ft.fit();
bg_param = fit_con.p;
acolor('r');
pl(fit_fun{1});
keep_figure;
ly 0.005 1



