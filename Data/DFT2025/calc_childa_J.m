fileName = 'e:/SHARE/Fe/Data/DFT2025/01_10_2025/dataset2-nk50-conventional-29sep25/chipm_lda_conv_nk50.h5';
if ~exist("childa_sqw","var")
    childa_sqw = read_jerome_cube(fileName);
end
% plot linear spin wave theroy simulations or just data read from
%  simulated dataset
overplot_with_data = false;

ff = multifit_sqw(childa_sqw);
ff = ff.set_fun(@sqw_bcc_hfm);

% chiLDA fitting params
gamma =78.5641;
gap =  0;            %
Seff = 402.1699;      %
J0 =  21.3837;       %
J1 = -24.0720;        %
J2 = -3.9393;       %
J3 =  10.7020;       %
J4 =  16.8650;        %
par_childa = {[8,gamma,Seff, gap, J0, J1, J2, J3, J4]};
ff = ff.set_pin(par_childa);
ff = ff.set_free([0,1,1,0,1,1,1,1,1]);

ff = ff.set_options('list', 2);
%[fit_j,par] = ff.fit();
if overplot_with_data
    cuts_name = "all_cuts_LDA";
    cuts_ds   = childa_sqw;
else
    cuts_name = "all_cuts_simJLDA";
end

if ~exist(cuts_name,"var")
    if ~overplot_with_data && ~exist("chi_ldaJSimDS","var")
        chi_ldaJSimDS = ff.simulate();
        cuts_ds = chi_ldaJSimDS;
    end

    all_cuts = spaghetty_cuts4DFT(cuts_ds,false);
    assignin("base",cuts_name,all_cuts);
else
    assignin("base","all_cuts",eval(cuts_name));
end

[calc_arr,labels] = gen_spaghetty_ds(all_cuts);

spaghetti_plot(calc_arr,'labels',labels);lz 0 4; hold on
if ~overplot_with_data
    return
end
dir = {[0,0,0],[1,0,0],[1/2,1/2,0],[0,0,0],[1/2,1/2,1/2],[1/2,1/2,0]};
[q_dir,dist,scales] = build_q_arr(dir,50,calc_arr);
disp_line = disp_bcc_hfm(q_dir{:},par_childa{1}(3:end));
plot(dist,disp_line{1},'r','LineWidth',2); hold on;