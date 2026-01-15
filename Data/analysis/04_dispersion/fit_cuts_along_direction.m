function fit_res = fit_cuts_along_direction(...
the_2Dcut,cut_en,dE_step,half_dE,use_mask,mask_par,cut_range_curvature)
%FIT_CUTS_ALONG_DIRECTION fits high symmetry 2D cut privided as input 
% by dividing it into multiple smaller cuts and fitting each of them
% with single J Heisenbergh model broadened by DHSO function.
% 
% Saves fitting results into mat file with special name. 
% if such file is present, loads and plots such file, does not do fitting
% 
if use_mask
    pref = 'mask';
else
    pref = 'range';    
end
res_name = sprintf("En_cut_2D%s_dir%s_dE%d.mat",pref,dir_name,2*half_dE);
if isfile(res_name)
    ld = load(res_name);
    fit_res = plot_result(ld.fit_res);
else
    plot(the_2Dcut); lz 0 2;
    %
    if use_mask
        keep = gen_mask(the_2Dcut,mask_par{:});
        the_2Dcut = the_2Dcut.mask(keep');
        plot(the_2Dcut); lz 0 2;
    else
        [q_par,e_lim] = qmax_cut(the_2Dcut ,cut_range_curvature);
        maxdE = the_2Dcut.data.img_range(2,4);
        hold on; plot(q_par,e_lim); ly(0,maxdE);
    end


    correct_ff = 1;
    T   = 8;
    gap = 0;    %
    gamma = 20;
    Seff0 =0.87;      %1.4489;
    J0 = 25;       %51.6079;


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
    for i = 1:N_points
        en = cut_en(i);
        if use_mask
            w2 = cut(the_2Dcut,[0,0.02,1],[en-half_dE ,dE_step,en+half_dE]);
            w1 = cut(w2,[],[en-half_dE ,en+half_dE]);
        else
            max_q = interp1(e_lim,q_par,en);
            w2 = cut(the_2Dcut,[0,0.02,max_q],[en-half_dE,dE_step,en+half_dE]);
            w1 = cut(w2,[],[en-half_dE ,en+half_dE]);            
        end
        acolor k;
        plot(w1);

        kk = tobyfit(w2);
        kk = kk.set_fun(@sqw_iron);
        kk = kk.set_pin({init_fg_params,w1});
        kk = kk.set_free(free_sw_param);
        kk = kk.set_bfun (@linear_bg2D); % set_bfun sets the background functions
        kk = kk.set_bpin ([0.05, 0,0]);  % initial background constant and gradient
        kk = kk.set_bfree ([1, 1, 1]);
        kk = kk.set_options('list',2);
        %[fit,par] = kk.simulate();
        [fit_obj,fit_par] = kk.fit();
        acolor r;
        w1fit = cut(fit_obj,[],[en-half_dE ,en+half_dE]);
        pl(w1fit);
        drawnow;
        gam(i) = abs(fit_par.p(3));
        gam_err(i) = abs(fit_par.sig(3));
        Seff(i) = fit_par.p(4);
        Seff_err(i) = abs(fit_par.sig(4));
        J0arr(i) = fit_par.p(6);
        J0_err(i) = abs(fit_par.sig(6));

        init_fg_params  = abs(fit_par.p);
    end
    en_bins = [cut_en-half_dE,cut_en(end)+half_dE];
    ax_x = IX_axis('Energy Transfer (meV)');
    ax_s = IX_axis('Scattering amplitude','mbarn/(Sr*fmu)');
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

    fit_res = struct("cut_range_curvature",cut_range_curvature, ...
        "S",S_eff,"gamma",G_eff,"J0",J0_eff);
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

function [q_par,e_lim] = qmax_cut(cut,ampl)
% calculates parabola which runs lower then magnon dispersion but higher
% then phonon dispersion signal
q_par  = 0.5*(cut.data.p{1}(1:end-1)+cut.data.p{1}(2:end));
qv_img = cut.data.proj.u'*q_par;
qv_cc  = cut.data.proj.transform_pix_to_img(qv_img);
q2_cc = sum(qv_cc.^2,1);
e_lim = ampl*q2_cc;
end
function keep = gen_mask(cut,A,phase,shift)

xx = 0.5*(cut.data.p{1}(1:end-1)+cut.data.p{1}(2:end));
yy = 0.5*(cut.data.p{2}(1:end-1)+cut.data.p{2}(2:end));
[imx,imy] = meshgrid(xx,yy);

keep = imy(:)>A*sin(phase*imx(:))+shift;
keep = reshape(keep,size(imx));
end
