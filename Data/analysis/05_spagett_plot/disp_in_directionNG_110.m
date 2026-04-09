%
cuts_map = containers.Map();
cuts_map('sNG_Ei200_all_sym_fix_ff_bg_removed') = {[0;130],[0.5,1.5,0]};
cuts_map('sNG_Ei400_all_sym_fix_ff_bg_removed') = {[130;195],[0.5,1.5,0]};
cuts_map('sNG_ei800_sel_sym_fix_ff_bg_removed') = {[195;400],[-0.5,2.5,0]};
%cuts_map('sGN_ei800_sel_sym_fix_ff_bg_removed_mlx') = {[195;400],[0.5,1.5,0]};
%cuts_map('GN_Ei1400_one_dir_fix_ff_bg_removed') = [250;360];

[w2,fh] = build_disp_in_dir(cuts_map,0.01,0.5,6,false);
data_ranges = cuts_map.values;
data_ranges = cellfun(@(x)x{1},data_ranges,'UniformOutput',false);
data_ranges  = [data_ranges{:}];
pan_data = struct('data_ranges',data_ranges,'combined_ds',w2);
save('NG_110_data','pan_data');
fh.UserData = w2.data;
savefig(fh,'NG_110_allEn_allSym_bgRem_ffCor')
