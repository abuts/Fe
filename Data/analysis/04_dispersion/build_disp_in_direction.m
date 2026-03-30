
cuts_map = containers.Map();
cuts_map('GP_Ei200_all_sym_fix_ff_bg_removed') = [0;115];
cuts_map('GP_Ei400_all_sym_fix_ff_bg_removed') = [115;172];
cuts_map('GP_Ei800_all_sym_fix_ff_bg_removed') = [172;250];
cuts_map('GP_Ei1400_selection') = [250;362];

keys  = cuts_map.keys();
zones = containers.Map('KeyType','double','ValueType','any');
sources = cell(1,numel(keys));
src_proj = repmat(line_proj,1,numel(keys));
for i=1:numel(keys)
    range= cuts_map(keys{i});
    %openfig(keys{i});
    %fh = gcf;    
    sources{i} = src(i);
    zones(i) = range;
    src_proj(i) = sources{i}.data.proj;
end

lp = sources{i}.data.proj;
targ_proj = lp;
targ_proj.type = 'aaa';
w2 = sqw_op_bin_pixels(sources,@combine_en_zones,{zones,lp,src_proj}, ...
    targ_proj,[0,0.005,0.5]*3.8256,[-0.1,0.1]*2.8566,[-0.1,0.1]*2.8566,[0,5,360], ...
    '-combine');
