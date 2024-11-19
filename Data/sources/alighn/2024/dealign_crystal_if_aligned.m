function dealign_crystal_if_aligned(data_source)
% dealign crystal if aligned and set lattice to the average expected value

rlu_corr = crystal_alignment_info([2.844,2.844,2.844],[90,90,90]);
sqw_obj = sqw(data_source,'file_backed',true);
if sqw_obj.pix.is_corrected
    rlu_corr.rotmat = sqw_obj.pix.alignment_matr';
end
clear sqw_obj;
change_crystal(data_source,rlu_corr);
