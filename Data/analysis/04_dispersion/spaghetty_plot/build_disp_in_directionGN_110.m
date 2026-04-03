%
cuts_map = containers.Map();
cuts_map('sGN_Ei200_all_sym_fix_ff_bg_removed') = {[0;130],[0.5,1.5,0]};
cuts_map('sGN_Ei400_all_sym_fix_ff_bg_removed') = {[130;195],[0.5,1.5,0]};
cuts_map('sGN_ei800_sel_sym_fix_ff_bg_removed') = {[195;400],[-0.5,2.5,0]};
%cuts_map('sGN_ei800_sel_sym_fix_ff_bg_removed_mlx') = {[195;400],[0.5,1.5,0]};
%cuts_map('GN_Ei1400_one_dir_fix_ff_bg_removed') = [250;360];

[w2,fh] = build_disp_in_dir(cuts_map);
