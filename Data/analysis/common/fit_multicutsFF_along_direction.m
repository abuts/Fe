function cuts_data = fit_multicutsFF_along_direction(...
    cuts_data,cut_name,n_dim2fit,cut_en,dE_step,half_dE,do_fit)
%FIT_CUTS_ALONG_DIRECTION fits high symmetry 2D cut provided as input
% by dividing it into multiple smaller cuts and fitting each of them
% with single J Heisenberg model broadened by DHSO function.
%
% Saves fitting results into mat file with special name.
% if such file is present, loads and plots such file, does not do fitting
%
if ~exist("do_fit","var")
    do_fit = true;
end
recover = true;

the_2Dcuts = cuts_data.(cut_name);
if ~iscell(the_2Dcuts)
    the_2Dcuts  = {the_2Dcuts};
end
fit_res_field_name = [cut_name,'_all_fit_par'];
if recover && isfield(cuts_data,fit_res_field_name) && ...
        numel(cuts_data.(fit_res_field_name)) == numel(cut_en)
    acolor g;
    all_fit_par = cuts_data.(fit_res_field_name);
    N_points = numel(all_fit_par);
    replot_fit_res = true;
    [S_eff,J0_eff,G_eff] = extract_fit_par(all_fit_par );
    plot(S_eff); keep_figure;
    plot(J0_eff);keep_figure
    plot(G_eff); keep_figure;    
    all_fit_par = num2cell(all_fit_par);
else
    N_points = numel(cut_en);    
    replot_fit_res = false;    
    all_fit_par = cell(1,N_points);    
end

gamma=10;Seff0=0.7917;J0=33.5;
correct_ff = 1;
gap = 0;    %
%gamma = 10; A =1; stiff = 90;


%init_fg_params0 = [correct_ff,35,gamma,A, gap, stiff, 0,  0,  0,  0];
%init_fg_params0 = [correct_ff,T,gamma,Seff0, gap, J0, 5.5,24, 40.,0]
init_fg_params0 = [correct_ff,8,gamma,Seff0,  0,   J0, 0,  0,  0,  0];
init_fg_params = init_fg_params0;


% for Ei=200
%init_bg_par = [0,0];
% for all other Ei
valid_fits = true(1,N_points);
finE = max(cut_en);
acolor k;
for i = 1:N_points
    en = cut_en(i);
    fprintf('******************************\n')
    fprintf('**** En = %g±%g going to %g\n',en,half_dE,finE);
    fprintf('******************************\n')
    en_range = [en-half_dE,dE_step,en+half_dE];
    if replot_fit_res
        init_fg_params = all_fit_par{i}.p;
    end
    %init_fg_params(2) = en; % for dsho_fun_q
    %[fit_obj,fit_par]=fit_single_set(the_2Dcuts,en,half_dE,dE_step,init_fg_params,init_bg_par,true);
    [fit_obj,fit_par,figa,figb]=fit_single_set_logBg(the_2Dcuts,n_dim2fit,en_range,init_fg_params,do_fit);
    if isempty(fit_obj)
        valid_fits(i) = false;
        continue;
    end
    if fit_par.p(3)<0 || fit_par.p(6) < 0
        init_fg_params  = init_fg_params0;
    else
        init_fg_params = fit_par.p;
    end
    max_hldr = IX_dataset_1d(fit_obj{1});
    xx = 0.5*(max_hldr.x(1:end-1)+max_hldr.x(2:end));
    [~,imx] = max(max_hldr.signal);
    fit_par.q_max = xx(imx);
    %init_fg_params  = abs(fit_par.p);
    all_fit_par{i} = fit_par;
end
all_fit_par = all_fit_par(valid_fits);

if do_fit
    [S_eff,J0_eff,G_eff] = extract_fit_par(all_fit_par );
    plot(S_eff); keep_figure;
    plot(J0_eff);keep_figure
    plot(G_eff); keep_figure;

    all_fit_par = [all_fit_par{:}];
    cuts_data.(fit_res_field_name) = all_fit_par;
end
end
