%
cuts_map = containers.Map();
cuts_map('sGH_Ei200_sel_sym_fix_ff_bg_removed') = [0;140];
cuts_map('sGH_Ei400_allSym_bg_rem_ff_corr') = [140;265];
cuts_map('sGH_Ei800_allSym_bg_rem_ff_corr') = [265;400];
%cuts_map('sGN_Ei1400_one_dir_fix_ff_bg_removed') = [265;400];

[w2,fh] = build_disp_in_dir(cuts_map);
