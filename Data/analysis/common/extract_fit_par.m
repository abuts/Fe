function [S_eff,J0_eff,G_eff] = extract_fit_par(all_fit_par)
%Extract global fit parameters from fit data to plot
%   Detailed explanation goes here
n_elem  = numel(all_fit_par);
cut_en  = zeros(1,n_elem);
gam     = zeros(1,n_elem);
gam_err = zeros(1,n_elem);
Seff    = zeros(1,n_elem);
Seff_err= zeros(1,n_elem);
J0arr   = zeros(1,n_elem);
J0_err  = zeros(1,n_elem);


for i=1:n_elem

    if iscell(all_fit_par)
        fit_par = all_fit_par{i};
    else
        fit_par = all_fit_par(i);
    end
    cut_en(i) = fit_par.en;
    gam(i) = abs(fit_par.p(3));
    gam_err(i) = abs(fit_par.sig(3));
    Seff(i) = fit_par.p(4);
    Seff_err(i) = abs(fit_par.sig(4));
    J0arr(i) = fit_par.p(6);
    J0_err(i) = abs(fit_par.sig(6));
end


[en_bins,idx] = sort(cut_en);
gam = gam(idx);
gam_err =  gam_err(idx);
Seff    = Seff(idx);
Seff_err = Seff_err(idx);
J0arr  = J0arr(idx);
J0_err = J0_err(idx);


ax_x = IX_axis('Energy Transfer (meV)');
ax_s = IX_axis('Scattering amplitude','mbarn/(Sr*fmu*meV)');
S_eff = IX_dataset_1d(en_bins,Seff,Seff_err);
S_eff.x_axis = ax_x;
S_eff.s_axis = ax_s;


G_eff = IX_dataset_1d(en_bins,gam,gam_err);
ax_s = IX_axis('DSHO broadening','meV');
G_eff.x_axis = ax_x;
G_eff.s_axis = ax_s;


J0_eff = IX_dataset_1d(en_bins,J0arr,J0_err);
J0_eff.x_axis = ax_x;
ax_s = IX_axis('J0','meV');
J0_eff.s_axis = ax_s;


end