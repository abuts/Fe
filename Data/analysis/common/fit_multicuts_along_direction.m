function [fit_res,res_name] = fit_multicuts_along_direction(...
    the_2Dcuts,cut_name_base,direction_name,n_dim2fit,cut_en,dE_step,half_dE,do_fit)
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

res_name = sprintf("%s_dir%s_dE%d_fitSlopeDE.mat",cut_name_base,direction_name,2*half_dE);
ref_name = res_name;
%wf =20;
%ref_name = sprintf("%s_dir%s_dE%d_fitSlopeDE.mat",cut_name_base,direction_name,wf);
replot_fit_res = false;
if isfile(ref_name)
    ld = load(ref_name);
    fnms = fieldnames(ld);
    fit_res = plot_j0_fit_result(ld.(fnms{1}),ref_name);
    replot_fit_res = true;
    %do_fit = false;
    cut_en = arrayfun(@(x)x.en,fit_res.all_fit_par);
end

%gamma=49.51;Seff0=0.7917;J0=33.5;
correct_ff = 1;
T   = 8;
gap = 0;    %
gamma = 10; Seff0 =1; J0 = 30;


%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, I, gm, H, J4];
%init_fg_params0 = [correct_ff,T,gamma,Seff0, gap, J0, 5.5,24, 40.,0]; % ei=200; iron with phonons
if iscell(the_2Dcuts{end})
    init_bg_par = the_2Dcuts{end};
    the_2Dcuts  = the_2Dcuts(1:end-1);
else
    init_bg_par = [];
end
init_fg_params0 = [correct_ff,T,gamma,Seff0, gap, J0, 0,  0,  0,  0];
init_fg_params = init_fg_params0;

if replot_fit_res
    N_points = numel(fit_res.all_fit_par);
else
    N_points = numel(cut_en);
end
all_fit_par = cell(1,N_points);
% for Ei=200
%init_bg_par = [0,0];
% for all other Ei
valid_fits = true(1,N_points);

for i = 1:N_points
    en = cut_en(i);
    fprintf('******************************\n')
    fprintf('**** En = %g±%g\n',en,half_dE)
    fprintf('******************************\n')
    en_range = [en-half_dE,dE_step,en+half_dE];
    if replot_fit_res
        init_fg_params = fit_res.all_fit_par(i).p;
    end
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
    if replot_fit_res
        fit_res_prev = fit_res;
    end
    fit_res = struct(...
        "direction",direction_name,...
        "cut_base",cut_name_base,...
        "S",S_eff,"gamma",G_eff,"J0",J0_eff,...
        "all_fit_par",all_fit_par);

    fit_res = plot_j0_fit_result(fit_res,res_name);
    if replot_fit_res
        [Sprev,Jprev,Gprev] = extract_fit_par(fit_res_prev.all_fit_par);
        plot_SJG_results(fit_res,'g',{'S','J0','gamma'},{[0,1.5],[20,60],[0,100]},{Sprev,Jprev,Gprev});
    end
end
end
