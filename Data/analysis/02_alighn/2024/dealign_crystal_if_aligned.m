function [alatt,dpsi_deg, gl_deg, gs_deg]= dealign_crystal_if_aligned(data_source)
% dealign crystal if aligned and set lattice to the average expected value

rlu_corr = crystal_alignment_info([2.844,2.844,2.844],[90,90,90]);
sqw_obj = sqw(data_source,'file_backed',true);
proj = sqw_obj.data.proj; % testing 
if sqw_obj.pix.is_corrected
    rlu_corr.rotmat = sqw_obj.pix.alignment_matr';
    change_crystal(data_source,rlu_corr);    
end
clear sqw_obj;
[alatt,~, dpsi_deg, gl_deg, gs_deg] = crystal_pars_correct(proj.u, proj.v, rlu_corr.alatt, rlu_corr.angdeg, 0, 0, 0, 0, rlu_corr);% testing 


