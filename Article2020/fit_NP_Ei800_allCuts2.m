function [ampl,bg] = fit_NP_Ei800_allCuts2()

data = fullfile(fileparts(fileparts(mfilename('fullpath'))),'Data','sqw','Fe_ei787.sqw');

Emax = 450;
dE   = 5;
Efit_min = 50;
Kun_width = 0.1;
kun_sym = 5;

Dqk = [-0.1,0.1];
Dql = [-0.1,0.1];
eval_background = false;
% view linear background substraction graphs for all cuts
view_background = true;


% proj = {projection([0,0,1],[0,1,0],'uoffset',[1.5,0.5,0]),projection([0,0,1],[0,1,0],'uoffset',[1.5,-0.5,0]),...
%     projection([0,0,1],[0,1,0],'uoffset',[0.5,1.5,0]),projection([0,0,1],[0,1,0],'uoffset',[-0.5,1.5,0]),...
%     projection([1,0,0],[0,1,0],'uoffset',[1,-0.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[1,-0.5,-0.5]),...
%     projection([1,0,0],[0,1,0],'uoffset',[1,0.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[1,0.5,-0.5]),...
%     projection([0,1,0],[-1,0,0],'uoffset',[ 0.5,1,0.5]),projection([0,1,0],[-1,0,0],'uoffset',[0.5,1,-0.5]),...
%     projection([0,1,0],[-1,0,0],'uoffset',[-0.5,1,0.5]),projection([0,1,0],[-1,0,0],'uoffset',[-0.5,1,-0.5])...
%     };
% kun_sym_dir = [1,1,1,1,3,3,3,3,2,2,2,2];
%
% proj = {projection([1,0,0],[0,1,0],'uoffset',[1,1.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[1,1.5,-0.5]),...    %1.8708
%     projection([0,1,0],[1,0,0],'uoffset',[1.5,1 ,0.5]),projection([0,1,0],[1,0,0],'uoffset',[1.5,1 ,-0.5]),...        %1.8708
%     projection([0,0,1],[0,1,0],'uoffset',[1.5,-0.5,-0.5]) ,projection([0,0,1],[0,1,0],'uoffset',[1.5,-0.5,-0.5]) ,...
%     projection([0,1,0],[1,0,0],'uoffset',[1.5,-0.5,0.5]) ,projection([0,1,0],[1,0,0],'uoffset',[1.5,-0.5,-0.5]),...  %1.6583
%     projection([1,0,0],[0,1,0],'uoffset',[-0.5,1.5,-0.5]),projection([1,0,0],[0,1,0],'uoffset',[-0.5,1.5,0.5]),...   %1.6583
%     projection([0,0,1],[0,1,0],'uoffset',[1.5,1.5,0])}; %2.1213
% kun_sym_dir = [3,3,2,2, 1,1,2,2,3,3, 1];


proj = {projection([0,1,0],[1,0,0],'uoffset',[2.5,-0.5,0.5]),projection([0,1,0],[1,0,0],'uoffset',[2.5,-0.5,-0.5]),...
    projection([1,0,0],[0,1,0],'uoffset',[-0.5,2.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[-0.5,2.5,-0.5]),...
    projection([0,0,1],[0,1,0],'uoffset',[2.5,-0.5,-0.5]),projection([0,0,1],[0,1,0],'uoffset',[2.5,0.5,-0.5]),...
    projection([0,0,1],[0,1,0],'uoffset',[-0.5,2.5,-0.5]),projection([0,0,1],[0,1,0],'uoffset',[0.5,2.5,-0.5])};
kun_sym_dir = [2,2,3,3,1,1,1,1];

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


w2all = cell(1,numel(proj));
w2tha = cell(1,numel(proj));
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
if eval_background
    bg_param0 = [0.3779 0.0129];
    bg_prod = projection([0,0,1],[0,1,0],'uoffset',[2.5,0,2]);
    bg_set1 = cut_sqw(data,bg_prod,[-2,1],Dqk ,Dql ,[50,dE,210]);
    acolor('k')
    plot(bg_set1);
    logy
    ft = multifit(bg_set1);
    ft = ft.set_fun(bg_fun);
    ft = ft.set_pin(bg_param0);
    [fit_fun,fit_con]= ft.fit();
    bg_param = fit_con.p;
    acolor('r');
    pl(fit_fun);
    keep_figure;
    fprintf(' Estimated background: [%f %f]\n',bg_param)
else
    % buckground estimated for first sequence of cuts (along h or k)
    %bg_param = [0.3779 0.0129];
    % buckground estimated for second sequence of cuts (along l)
    bg_param = [0.382479 0.012739];
end



for i=1:numel(proj)
    w2all{i} = cut_sqw(data,proj{i},[-2,0.05,3],Dqk ,Dql ,[0,dE,800]);
    w2all{i} = set_sample_and_inst(w2all{i},sample,@maps_instrument,'-efix',600,'S');
    liny
    plot(w2all{i});
    if view_background
        bg_real1D = cut_sqw(w2all{i},proj{i},[-2,3],Dqk ,Dql ,[0,dE,800]);
        bg_eval1D = func_eval(bg_real1D,bg_fun,bg_param);
        acolor('k');
        plot(bg_real1D)
        acolor('r')
        pl(bg_eval1D)
        logy
        keep_figure;
    end
    %
    
    %    keep_figure
    bg = func_eval(w2all{i},@(en,q,par)(par(1)*exp(-par(2)*(en-50))),bg_param);
    disp = w2all{i}-bg;
    plot(disp);
    liny
    
    
    keep_figure
    ly 0 500
    lz  0 0.2
    %    w2tha{i} = sqw_eval(w2all{i},@disp_dft_kun4D_lint,[1,0]);
    %    plot(w2tha{i});
    %    keep_figure
    %    ly 0 500
    %    lz  0 5
end
com_cut = w2all{numel(proj)};
kk = tobyfit(com_cut);
kk = kk.set_fun(@disp_dft_kun4D_lint,[0.2546,0],[1,0]);
kk = kk.set_bfun(@(q,en,par)(par(1)*exp(-par(2)*(en-50))),[0.3050,0.0226]);
%
kk = kk.set_mc_points(10);
% %profile on;
kk = kk.set_options('listing',2,'fit_control_parameters',[1.e-2;60;1.e-3]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
% %profile on;
[w2D_arr1_tf,fp_arr1]=kk.simulate;
plot(w2D_arr1_tf)
keep_figure




%ly -2.5 2.5
en = Efit_min:dE:Emax;
nfp = numel(en);
sv_ampl = NaN*zeros(1,numel(en));
fit_err = NaN*zeros(1,numel(en));
bg_fit   = NaN*zeros(1,numel(en));
bg_err   = NaN*zeros(1,numel(en));
bg_par = struct();
n_plots = numel(proj);
bg_par.all_bg = NaN*zeros(numel(en),n_plots);
bg_par.all_bge = NaN*zeros(numel(en),n_plots);
bg_par.en = NaN*zeros(numel(en),1);


fgs = fig_spread('-tight');
for i=1:nfp
    cut2fit = cell(1,numel(proj));
    for j=1:numel(proj)
        cut2fit{j}  = cut_sqw(w2all{j},proj{j},[-3,0.02,3],Dqk ,Dql,[en(i)-dE,en(i)+dE]);
        if isempty(cut2fit{j}.data.pix)
            cut2fit{j} = [];
        end
    end
    valid = cellfun(@(ds)(isa(ds,'sqw')),cut2fit);
    if ~any(valid)
        break;
    else
        cut2fit = cut2fit(valid);
        kun_sym_sel = kun_sym_dir(valid);
    end
    
    [A,err,bg_val,bg_er,fgs,bp,bpsig]=fit_encut2(cut2fit,fgs,kun_sym,kun_sym_sel,Kun_width);
    sv_ampl(i) = A;
    fit_err(i) = err;
    bg_fit(i) = bg_val;
    bg_err(i) = bg_er;
    %
    bg_par.en(i) = en(i);
    bg_par.all_bg(i,valid)  = bp;
    bg_par.all_bge(i,valid) = bpsig;
    
    save('bg_model_data_PN','bg_par');
end
acolor('b')
errorbar(en,sv_ampl,fit_err)
hold on
acolor('r')
errorbar(en,bg_fit,bg_err)
%
ampl = IX_dataset_1d(en,sv_ampl,fit_err);
acolor('b')
figure;
pd(ampl);
acolor('r')
bg = IX_dataset_1d(en,bg_fit,bg_err);
pd(bg);


