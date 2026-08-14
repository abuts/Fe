function [fit_res,res_name] = fit_multicuts_along_direction(...
    the_2Dcuts,cut_name_base,direction_name,cut_en,dE_step,half_dE,do_fit)
%FIT_CUTS_ALONG_DIRECTION fits high symmetry 2D cut privided as input
% by dividing it into multiple smaller cuts and fitting each of them
% with single J Heisenbergh model broadened by DHSO function.
%
% Saves fitting results into mat file with special name.
% if such file is present, loads and plots such file, does not do fitting
%
if ~e

res_name = sprintf("%s_dir%s_dE%d_fix_bg_slope.mat",cut_name_base,direction_name,2*half_dE);
if isfile(res_name)
    ld = load(res_name);
    fit_res = plot_j0_fit_result(ld.fit_res);
else

    correct_ff = 1;
    T   = 8;
    gap = 0;    %
    gamma = 20;
    Seff0 =1;      %1.4489;
    J0 = 30;


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

    N_points = numel(cut_en);
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

        [fit_obj,fit_par]=fit_single_set(the_2Dcuts,en,half_dE,dE_step,init_fg_params,init_bg_par,true);
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
    
    [S_eff,G_eff,J0_eff] = extract_fit_par(all_fit_par );
    plot(S_eff); keep_figure;    
    plot(J0_eff);keep_figure 
    plot(G_eff); keep_figure;

    all_fit_par = [all_fit_par{:}];
    fit_res = struct(...
        "direction",direction_name,...
        "cut_base",cut_name_base,...
        "S",S_eff,"gamma",G_eff,"J0",J0_eff,...
        "all_fit_par",all_fit_par);
    fit_res = plot_j0_fit_result(fit_res,res_name);

end
end
