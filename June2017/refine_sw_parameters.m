function [en_sw,S_sw,S_sw_err,Gamma,Gamma_err] = ...
    refine_sw_parameters(cuts_blocks,fname,cut_dir_id)

en_list = cuts_blocks.keys;
en_list_num = cellfun(@str2num,en_list);
en_list_num = sort(en_list_num);
en_list  = arrayfun(@num2str,en_list_num,'UniformOutput',false);

n_en = numel(en_list);

en_sw = zeros(n_en,1);
S_sw  = zeros(n_en,1);
S_sw_err = zeros(n_en,1);
Gamma   = zeros(n_en,1);
Gamma_err = zeros(n_en,1);
for i=1:n_en
    en_key = en_list{i};
    cuts_group = cuts_blocks(en_key);
    n_cuts = numel(cuts_group);
    
    cut_info1 = cuts_group{1};
    en_sw(i) = cut_info1.en;
    disp('****************************************************')
    fprintf('**** Processing dE=%d, nCuts = %d\n',en_sw(i),n_cuts)
    
    rez_file = sprintf('CB_dE%d_%s_Dir%s',en_sw(i),fname,cut_dir_id);
    if exist([rez_file,'.mat'],'file')==2
        load(rez_file);
    else
       
        %cuts_list = cellfun(@(dat)(dat.cut),cuts_group);
        cuts_list = repmat(cut_info1.cut,n_cuts,1);
        for j=1:n_cuts
            cuts_list(j) = cuts_group{j}.cut;
        end
        
        
        fg_par_list = cellfun(@(dat)(dat.fg_par),cuts_group,'UniformOutput',false);
        bg_par_list = cellfun(@(dat)(dat.bg_par),cuts_group,'UniformOutput',false);
        fitpar = reshape([fg_par_list{:}],10,n_cuts)';
        fitpar  = sum(fitpar,1)/n_cuts;
        disp('Fit guess:')
        disp(fitpar)
        
        %fitpar = [ff, T, gamma, Seff, gap, J1, 0 0 0 0];
        
        kk = tobyfit2(cuts_list);
        kk = kk.set_fun(@sqw_iron,fitpar,[0,0,1,1,0,0,0,0,0,0]);
        kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),bg_par_list);
        
        kk = kk.set_mc_points(10);
        %profile on;
        kk = kk.set_options('listing',0,'fit_control_parameters',[1.e-3;60;1.e-6]);
        [w1D_arr1_tf,fp_arr1]=kk.fit;
        %[w1D_arr1_tf,fp_arr1]=kk.simulate;
        save(rez_file,'cuts_list','w1D_arr1_tf','fp_arr1');
        
    end
    S_sw(i) = fp_arr1.p(4);
    S_sw_err(i) = fp_arr1.sig(4);
    Gamma(i) = fp_arr1.p(3);
    Gamma_err(i) = fp_arr1.sig(3);
    
    
    disp('Fit params:')
    disp(fp_arr1.p)
    disp('Fit errors:')
    disp(fp_arr1.sig)
    disp('****************************************************')
    
    for j=1:numel(w1D_arr1_tf)
        acolor('k');
        plot(cuts_list(j));
        acolor('r');
        pd(w1D_arr1_tf(j));
        pause(1)
    end
    disp('****************************************************')
end

