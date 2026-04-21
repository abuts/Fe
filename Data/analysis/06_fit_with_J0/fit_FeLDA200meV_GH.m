if ~exist('all_cuts_LDA','var')
    load('all_spaghetti_cuts_LDA.mat');
end

dir_name  = "GH";

dE_step = 2; %original energy transfer step data were binned to. No point in going finer
half_dE = 4; % half width of data binning
cut_en = 30:2:158;

the_2Dcut = all_cuts_LDA(dir_name);
fit_res_theor_GH = fit_theoretical_cuts_along_direction(...
    the_2Dcut,dir_name,cut_en,dE_step,half_dE);
dir_name  = "NG";
the_2Dcut = all_cuts_LDA(dir_name);
fit_res_theor_GN = fit_theoretical_cuts_along_direction(...
    the_2Dcut,dir_name,cut_en,dE_step,half_dE);
dir_name  = "GP";
the_2Dcut = all_cuts_LDA(dir_name);
fit_res_theor_GP = fit_theoretical_cuts_along_direction(...
    the_2Dcut,dir_name,cut_en,dE_step,half_dE);
