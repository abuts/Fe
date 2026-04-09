cuts_map = containers.Map();
cuts_map('sHN_Ei200_2Sym_bg_rem_ff_corr') = [0;150];
cuts_map('sHN_Ei400_2Sym_bg_rem_ff_corr')        = [150;255];
cuts_map('sHN_Ei800_cut_sym_bg_rem_ff_corr.fig') = [255;450];
%cuts_map('sGP_Ei1400_selection') = [250;360];

%[w2,fh] = build_disp_in_dir(cuts_map);
n_existing_figures = 0;
[w2,fh] = build_disp_in_dir(cuts_map,0.01,0.5,n_existing_figures,true);
data_ranges = cuts_map.values;
data_ranges  = [data_ranges{:}];
pan_data = struct('data_ranges',data_ranges,'combined_ds',w2);
save('HN__010_0p50p50_data','pan_data');
fh.UserData = w2.data;
savefig(fh,'HN_010_0p50p50_allEn_allSym_bgRem_ffCor')
