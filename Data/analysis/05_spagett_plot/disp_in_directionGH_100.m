%
cuts_map = containers.Map();
cuts_map('sGH_Ei200_sel_sym_fix_ff_bg_removed') = [0;140];
cuts_map('sGH_Ei400_allSym_bg_rem_ff_corr') = [140;250];
cuts_map('sGH_Ei800_allSym_bg_rem_ff_corr') = [250;450];
%cuts_map('sGN_Ei1400_one_dir_fix_ff_bg_removed') = [265;400];

%[w2,fh] = build_disp_in_dir(cuts_map);
n_existing_figures = 10;
[w2,fh] = build_disp_in_dir(cuts_map,0.02,1,n_existing_figures,false);
data_ranges = cuts_map.values;
data_ranges  = [data_ranges{:}];
pan_data = struct('data_ranges',data_ranges,'combined_ds',w2);
save('GH_100_data','pan_data');
fh.UserData = w2.data;
savefig(fh,'GH_100_allEn_allSym_bgRem_ffCor')
