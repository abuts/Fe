fileName = 'e:/SHARE/Fe/Data/DFT2025/01_10_2025/dataset2-nk50-conventional-29sep25/chipm_qsgw_conv_nk50.h5 ';
if ~exist("chigsgw_sqw","var")
    chigsgw_sqw = read_jerome_cube(fileName);
end
labels   = {' \Gamma','H','N',' \Gamma','P','N'};
directions = {'GH','HN','NG','GP','PN'};

if ~exist("all_cuts_GSGW","var")
    all_cuts_GSGW = spaghetty_cuts4DFT(chigsgw_sqw,false);
end

calc_arr = repmat(IX_dataset_2d(),numel(directions),1);
q_bg = zeros(3,numel(directions));
for i=1:numel(calc_arr)
    the_cut = all_cuts_GSGW(directions{i});
    x = 0.5*(the_cut.p{1}(1:end-1)+the_cut.p{1}(2:end));
    y = 0.5*(the_cut.p{2}(1:end-1)+the_cut.p{2}(2:end));    
    ds =IX_dataset_2d(x-min(x),y,the_cut.s);
    ds.title = [labels{i},labels{i+1}];
    calc_arr(i) = ds;
end

spaghetti_plot(calc_arr,'labels',labels);



