function [obj,init_fg_params,init_bg_params,emin_real,emax_real] = ...
    init_fitting(obj,filenames,file_directions,e_min,e_max)
% load initial cut files and extract initial parameters for multifit
%
% Inputs:
% filenames -- list of files containing initial cuts parameters to load
% file_directions -- list of the vector, defining the cut directions
% e_min   -- minimal energy (inclusive) for for cuts to include in fitting
% e_max   -- maximal energy (inclusive) for for cuts to include in fitting
%



n_files = numel(filenames);
cut_binds_map = containers.Map(); % defines map, connecting various equivalent cut numbers
% e.i mapping of cut_id as a key and the list of the equivalent
% cuts numbers as a value.
cuts_list = {};
init_bg_params = {};
init_fg_params = {};
fitpar_av = zeros(1,10);
cut_count = 0;
av_count = 0;

par_pattern = [1,8,80,2.5,0,obj.J0,obj.J1,obj.J2,obj.J3,obj.J4];
cut_en_f = @(x)(0.5*(x.data.iint(1,3)+x.data.iint(2,3)));
emin_real  = inf;
emax_real  = -inf;
for i=1:n_files
    data_file = filenames{i};
    
    [~,fname] = fileparts(data_file);
    fprintf('reloading cut file: %s %d#%d\n',fname,i,n_files);
    ld = load(data_file);
    cuts_en = arrayfun(cut_en_f,ld.cut_list);
    cuts_2_use = cuts_en>=e_min &cuts_en<=e_max;
    n_cuts= sum(cuts_2_use);
    if n_cuts == 0
        continue
    end
    cuts_en = cuts_en(cuts_2_use);
    emin_real = min(min(cuts_en),emin_real);
    emax_real = max(max(cuts_en),emax_real);
    
    % Build binds between equivalent cuts:
    used_cuts = ld.cut_list(cuts_2_use);
    %     former_fits = ld.w1D_arr1_tf(cuts_2_use);
    %     for ii=1:numel(former_fits)
    %         acolor('k');
    %         plot(used_cuts(ii));
    %         acolor('r');
    %         pd(former_fits(ii));
    %         pause(1)
    %     end
    
    
    direction = file_directions{i};
    cut_dir_id = direction_id(direction);
    for j=1:n_cuts
        en = cut_en_f(used_cuts(j));
        bind_id = [num2str(en),cut_dir_id];
        if cut_binds_map.isKey(bind_id)
            val = cut_binds_map(bind_id);
            val{end+1} = cut_count+j;
            cut_binds_map(bind_id)= val;
        else
            cut_binds_map(bind_id) = {cut_count+j};
        end
    end
    cut_count = cut_count + n_cuts;
    
    
    cuts_list = [cuts_list(:);used_cuts(:)];
    
    
    cut_fiterr = reshape([ld.fp_arr1.sig{cuts_2_use}],10,n_cuts)';
    cut_fitpar = reshape([ld.fp_arr1.p{cuts_2_use}],10,n_cuts)';
    cut_fitpar(:,3) = abs(cut_fitpar(:,3));
    cut_fitpar(:,6) = obj.J0;
    cut_fitpar(:,7) = obj.J1;
    cut_fitpar(:,8) = obj.J2;
    cut_fitpar(:,9) = obj.J3;
    cut_fitpar(:,10)= obj.J4;
    
    par_pattern_md = repmat(par_pattern,size(cut_fitpar,1),1);
    
    
    
    
    not_valid = cut_fiterr>10 |cut_fitpar> par_pattern_md | isnan(cut_fiterr) | isnan(cut_fitpar) ;
    if any(reshape(not_valid,1,numel(not_valid)))
        if av_count>0
            ffa = fitpar_av/av_count;
        else
            ffa  = par_pattern;
        end
        cor = repmat(ffa,n_cuts,1);
        cut_fitpar(not_valid) = cor(not_valid);
        %ld.fp_arr1.p{not_valid} = ffa;
    else
        fitpar_av  = fitpar_av+sum(cut_fitpar,1);
        av_count   = av_count + n_cuts;
    end
    
    p = arrayfun(@(ind)(cut_fitpar(ind,:)),1:n_cuts,'UniformOutput',false);
    
    init_bg_params = {init_bg_params{:},ld.fp_arr1.bp{cuts_2_use}};
    init_fg_params  = {init_fg_params{:},p{:}};
    
end
%n_cuts = cut_count;
%fitpar_av = fitpar_av/av_count   ;

% build bind map in a form multifit would accept
obj.equal_cuts_map = cut_binds_map;
obj.cuts_list_ = cuts_list;

%param_binds = obj.build_cuts_binding();




