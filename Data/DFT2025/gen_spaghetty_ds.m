function [calc_arr,labels ] = gen_spaghetty_ds(all_cuts)
% Convert map of dnd obects representing BCC spaghetty cuts into 
% array of datasets, suitable for spaghetty pliot
%
% Input: Map, containing 
labels   = {' \Gamma','H','N',' \Gamma','P','N'};
directions = {'GH','HN','NG','GP','PN'};
calc_arr = repmat(IX_dataset_2d(),numel(directions),1);

for i=1:numel(calc_arr)
    the_cut = all_cuts(directions{i});
    x = 0.5*(the_cut.p{1}(1:end-1)+the_cut.p{1}(2:end));
    y = 0.5*(the_cut.p{2}(1:end-1)+the_cut.p{2}(2:end));
    ds =IX_dataset_2d(x-min(x),y,the_cut.s);
    ds.title = [labels{i},labels{i+1}];
    calc_arr(i) = ds;
end
end