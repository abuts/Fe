cuts_map = containers.Map();
cuts_map('sGP_Ei200_all_sym_fix_ff_bg_removed') = [0;115];
cuts_map('sGP_Ei400_allSym_bg_rem_ff_corr') = [115;200];
cuts_map('sGP_Ei800_allSym_bg_rem_ff_corr.fig') = [200;450];
%cuts_map('sGP_Ei1400_selection') = [250;360];

%[w2,fh] = build_disp_in_dir(cuts_map);
n_existing_figures = 4;
[w2,fh] = build_disp_in_dir(cuts_map,0.01,0.5,n_existing_figures,false);
data_ranges = cuts_map.values;
data_ranges  = [data_ranges{:}];
pan_data = struct('data_ranges',data_ranges,'combined_ds',w2);
save('GP_0p50p50p5_data','pan_data');
fh.UserData = w2.data;
savefig(fh,'GP_0p50p50p5_allEn_allSym_bgRem_ffCor')
