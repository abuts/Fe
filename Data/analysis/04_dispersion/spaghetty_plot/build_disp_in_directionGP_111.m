cuts_map = containers.Map();
cuts_map('sGP_Ei200_all_sym_fix_ff_bg_removed') = [0;115];
cuts_map('sGP_Ei400_all_sym_fix_ff_bg_removed') = [115;170];
cuts_map('sGP_Ei800_all_sym_fix_ff_bg_removed') = [170;250];
cuts_map('sGP_Ei1400_selection') = [250;360];

[w2,fh] = build_disp_in_dir(cuts_map);
