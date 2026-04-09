cuts_map = containers.Map();
cuts_map('sPN_Ei200_AllSym_bg_rem_ff_corr') = [0;120];
cuts_map('sPN_Ei400_AllSym_bg_rem_ff_corr') = [120;200];
cuts_map('sPN_Ei800_allSym_bg_rem_ff_corr') = [200;450];
%cuts_map('sPN_Ei800_NSym_bg_rem_ff_corr') = [200;450];

%[w2,fh] = build_disp_in_dir(cuts_map);
n_existing_figures = 4;
[w2,fh] = build_disp_in_dir(cuts_map,0.01,0.5,n_existing_figures,false);
data_ranges = cuts_map.values;
data_ranges  = [data_ranges{:}];
pan_data = struct('data_ranges',data_ranges,'combined_ds',w2);
save('PN_0p50p50p5_0p50p50_data_T1','pan_data','-v7.3');
fh.UserData = w2.data;
savefig(fh,'PN_0p50p50p5_0p50p50_allEn_allSym_bgRem_ffCorT1')
