function [ampl,bg] = fit_NP_Ei800_allCuts()
Emax = 450;
dE   = 5;
Efit_min = 50;
Kun_width = 0.1;
kun_sym = 5;

Dqk = [-0.1,0.1];
Dql = [-0.1,0.1];


proj = {projection([0,0,1],[0,1,0],'uoffset',[1.5,0.5,0]),projection([0,0,1],[0,1,0],'uoffset',[1.5,-0.5,0]),...
    projection([0,0,1],[0,1,0],'uoffset',[0.5,1.5,0]),projection([0,0,1],[0,1,0],'uoffset',[-0.5,1.5,0]),...
    projection([1,0,0],[0,1,0],'uoffset',[1,-0.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[1,-0.5,-0.5]),...
    projection([1,0,0],[0,1,0],'uoffset',[1,0.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[1,0.5,-0.5]),...
    projection([0,1,0],[-1,0,0],'uoffset',[ 0.5,1,0.5]),projection([0,1,0],[-1,0,0],'uoffset',[0.5,1,-0.5]),...
    projection([0,1,0],[-1,0,0],'uoffset',[-0.5,1,0.5]),projection([0,1,0],[-1,0,0],'uoffset',[-0.5,1,-0.5])...
    };
kun_sym_dir = [1,1,1,1,3,3,3,3,2,2,2,2];

proj = {projection([1,0,0],[0,1,0],'uoffset',[1,1.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[1,1.5,-0.5]),...    %1.8708
    projection([0,1,0],[1,0,0],'uoffset',[1.5,1 ,0.5]),projection([0,1,0],[1,0,0],'uoffset',[1.5,1 ,-0.5]),...        %1.8708
    projection([0,0,1],[0,1,0],'uoffset',[1.5,-0.5,-0.5]) ,projection([0,0,1],[0,1,0],'uoffset',[1.5,-0.5,-0.5]) ,...
    projection([0,1,0],[1,0,0],'uoffset',[1.5,-0.5,0.5]) ,projection([0,1,0],[1,0,0],'uoffset',[1.5,-0.5,-0.5]),...  %1.6583
    projection([1,0,0],[0,1,0],'uoffset',[-0.5,1.5,-0.5]),projection([1,0,0],[0,1,0],'uoffset',[-0.5,1.5,0.5]),...   %1.6583
    projection([0,0,1],[0,1,0],'uoffset',[1.5,1.5,0])}; %2.1213
kun_sym_dir = [3,3,2,2, 1,1,2,2,3,3, 1];


proj = {projection([0,1,0],[1,0,0],'uoffset',[2.5,-0.5,0.5]),projection([0,1,0],[1,0,0],'uoffset',[2.5,-0.5,-0.5]),...
    projection([1,0,0],[0,1,0],'uoffset',[-0.5,2.5,0.5]),projection([1,0,0],[0,1,0],'uoffset',[-0.5,2.5,-0.5]),...
    projection([0,0,1],[0,1,0],'uoffset',[2.5,-0.5,-0.5]),projection([0,0,1],[0,1,0],'uoffset',[2.5,0.5,-0.5]),...
    projection([0,0,1],[0,1,0],'uoffset',[-0.5,2.5,-0.5]),projection([0,0,1],[0,1,0],'uoffset',[0.5,2.5,-0.5])};
kun_sym_dir = [2,2,3,3,1,1,1,1];


%pr = projection([1,-1,0],[1,1,0]);
dat = fullfile(pwd,'sqw','data','Fe_ei787.sqw');


w2all = cell(1,numel(proj));
w2tha = cell(1,numel(proj));
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

for i=1:numel(proj)
    w2all{i} = cut_sqw(dat,proj{i},[-2,0.05,3],Dqk ,Dql ,[0,dE,800]);
    w2all{i} = set_sample_and_inst(w2all{i},sample,@maps_instrument_for_tests,'-efix',600,'S');
    plot(w2all{i});
    ly 0 500
    lz  0 0.2
    w2tha{i} = sqw_eval(w2all{i},@disp_kun_calc,[1,0,kun_sym,kun_sym_dir(i),Kun_width]);
    plot(w2tha{i});
    ly 0 500
    lz  0 5
end




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
    
    [A,err,bg_val,bg_er,fgs,bp,bpsig]=fit_encut(cut2fit,fgs,kun_sym,kun_sym_sel,Kun_width);
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


