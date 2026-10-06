function [S_en,J_en,G_en,Sq_en,proj]= display_EiDep_blocks(CutsFitsStruc,dir_name,dir_tag,fit_res_field,separate_fig)
% extract three energy dependent fit parameters from fit_par
% property calculated for 3 incident energies and display them on common
% plot as function of energy transfer and incident energy

base_fld_name = ['Ei200_',dir_name];

[S_Ei200,J_Ei200,Gam_Ei200,S_Ei200q] = extract_fit_par( ...
    CutsFitsStruc.([base_fld_name,'_',fit_res_field]));
[S_Ei400,J_Ei400,Gam_Ei400,S_Ei400q] = extract_fit_par( ...
    CutsFitsStruc.(['Ei400_',dir_name,'_',fit_res_field]));
[S_Ei800,J_Ei800,Gam_Ei800,S_Ei800q] = extract_fit_par( ...
    CutsFitsStruc.(['Ei800_',dir_name,'_',fit_res_field]));
S_en = [S_Ei200,S_Ei400,S_Ei800];
J_en = [J_Ei200,J_Ei400,J_Ei800];
G_en = [Gam_Ei200,Gam_Ei400,Gam_Ei800];


proj = CutsFitsStruc.(base_fld_name).data.proj;
S_Ei200q = transform_img_path_to_pix_path(S_Ei200q,proj);
S_Ei400q = transform_img_path_to_pix_path(S_Ei400q,proj);
S_Ei800q = transform_img_path_to_pix_path(S_Ei800q,proj);

Sq_en = [S_Ei200q,S_Ei400q,S_Ei800q];

plot_fp(separate_fig,['offset ',dir_tag], ...
    S_en, J_en,G_en)
end
