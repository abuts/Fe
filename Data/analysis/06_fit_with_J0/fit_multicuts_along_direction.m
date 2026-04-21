function fit_res = fit_multicuts_along_direction(...
    the_2Dcuts,cut_name_base,direction_name,cut_en,dE_step,half_dE)
%FIT_CUTS_ALONG_DIRECTION fits high symmetry 2D cut privided as input
% by dividing it into multiple smaller cuts and fitting each of them
% with single J Heisenbergh model broadened by DHSO function.
%
% Saves fitting results into mat file with special name.
% if such file is present, loads and plots such file, does not do fitting
%

res_name = sprintf("%s_dir%s_dE%d_fix_bg_slope.mat",cut_name_base,direction_name,2*half_dE);
if isfile(res_name)
    ld = load(res_name);
    fit_res = plot_result(ld.fit_res);
else

    correct_ff = 1;
    T   = 8;
    gap = 0;    %
    gamma = 40;
    Seff0 =10;      %1.4489;
    J0 = 30;       %51.6079;


    %init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
    init_fg_params = [correct_ff,T,gamma,Seff0, gap, J0, 0,   0,  0,  0];
    free_sw_param  = [0          0, 1   ,1   , 0,    1, 0,   0,  0,  0];

    N_points = numel(cut_en);
    gam = zeros(1,N_points);
    gam_err = zeros(1,N_points);
    Seff    = zeros(1,N_points);
    Seff_err= zeros(1,N_points);
    J0arr   = zeros(1,N_points);
    J0_err   = zeros(1,N_points);
    all_fit_par = cell(1,N_points);
    for i = 1:N_points
        en = cut_en(i);
        fprintf('******************************\n')
        fprintf('**** En = %g±%g\n',en,half_dE)
        fprintf('******************************\n')
        n_samples = numel(the_2Dcuts);
        sub_cuts = cell(1,n_samples);
        valid = true(1,n_samples);
        nplots = 0;
        bg_const = 0;
        for j=1:n_samples
            sub_cuts{j} = cut(the_2Dcuts{j},0.02,[en-half_dE ,dE_step,en+half_dE]);
            %sub_cuts{j} = cut(the_2Dcuts{j},0.02,[en-half_dE ,en+half_dE]);
            valid(j) = sub_cuts{j}.num_pixels>0;
            if valid(j)
                nplots = nplots+1;
                cut_range = sub_cuts{j}.data.axes.get_cut_range;
                cut_range = cut_range{1};
                w0 = cut(sub_cuts{j},[cut_range(1),cut_range(3)],[en-half_dE ,en+half_dE],'-nopix');
                %w0 = cut(sub_cuts{j},[cut_range(1),cut_range(3)],'-nopix');
                bg_const = bg_const+w0.s;
            end
        end
        sub_cuts = sub_cuts(valid);
        hkl_proj = sub_cuts{1}.data.proj; %get the projection, used for converting from hkl to Crystal Cartesian
        hkl_proj.offset = [0,0,0];

        bg_const = bg_const/nplots;


        kk = tobyfit(sub_cuts{:});

        kk = kk.set_fun(@sqw_iron);
        kk = kk.set_pin({init_fg_params,hkl_proj});
        kk = kk.set_free(free_sw_param);
        kk = kk.set_bfun (@linear_bg2D); % set_bfun sets the background functions
        kk = kk.set_bpin ([bg_const, 0, 0]);  % initial background constant and gradient
        kk = kk.set_bfree ([1, 0, 1]);
        %kk = kk.set_bfree ([1, 1]);
        kk = kk.set_options('list',2);

        % [fit_obj,fit_par] = kk.simulate();
        % w1 = cut(sub_cuts,[],[en-half_dE ,en+half_dE],'-nopix');
        % acolor k;
        % plot(w1);
        % acolor r;
        % w1fit = cut(fit_obj,[],[en-half_dE ,en+half_dE]);
        % pl(w1fit);
        % %pl(fit_obj);
        % return
        [fit_obj,fit_par] = kk.fit();
        colour={'k','b','r','b','g','b'};
        for j=1:nplots
            w1 = cut(sub_cuts{j},[],[en-half_dE ,en+half_dE],'-nopix');
            acolor(colour{2*j-1});
            if j == 1
                plot(w1);
            else
                pd(w1);
            end
            acolor(colour{2*j});
            w1fit = cut(fit_obj{j},[],[en-half_dE ,en+half_dE]);
            pl(w1fit);
            drawnow;
        end
        init_fg_params = fit_par.p;
        gam(i) = abs(fit_par.p(3));
        gam_err(i) = abs(fit_par.sig(3));
        Seff(i) = fit_par.p(4);
        Seff_err(i) = abs(fit_par.sig(4));
        J0arr(i) = fit_par.p(6);
        J0_err(i) = abs(fit_par.sig(6));

        %init_fg_params  = abs(fit_par.p);
        all_fit_par{i} = fit_par;
    end
    en_bins = [cut_en-half_dE,cut_en(end)+half_dE];
    ax_x = IX_axis('Energy Transfer (meV)');
    ax_s = IX_axis('Scattering amplitude','mbarn/(Sr*fmu*meV)');
    S_eff = IX_dataset_1d(en_bins,Seff,Seff_err);
    S_eff.x_axis = ax_x;
    S_eff.s_axis = ax_s;
    plot(S_eff)

    G_eff = IX_dataset_1d(en_bins,gam,gam_err);
    ax_s = IX_axis('DSHO broadening','meV{^-1}');
    G_eff.x_axis = ax_x;
    G_eff.s_axis = ax_s;

    J0_eff = IX_dataset_1d(en_bins,J0arr,J0_err);
    J0_eff.x_axis = ax_x;
    ax_s = IX_axis('J0','meV');
    J0_eff.s_axis = ax_s;

    all_fit_par = [all_fit_par{:}];
    fit_res = struct(...
        "direction",direction_name,...
        "cut_base",cut_name_base,...
        "S",S_eff,"gamma",G_eff,"J0",J0_eff,...
        "all_fit_par",all_fit_par);
    fit_res = plot_result(fit_res,res_name);
    save(res_name,'fit_res');
end
end

function fit_res = plot_result(fit_res,varargin)
if nargin > 1
    file_name = varargin{1};
    file_name = strrep(file_name,'_','\_');
    fit_res.S.title = ['Amplitude, ',file_name];
    fit_res.gamma.title =['Gamma, ',file_name ];
    fit_res.J0.title =['J0, ',file_name];
end
plot(fit_res.S); keep_figure;
plot(fit_res.gamma); keep_figure;
plot(fit_res.J0); keep_figure;
end

