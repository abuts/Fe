function [calc_arr,q_cen] = import_Kun(varargin)
labels   = {'G','H','N','G','P','N'};
datasets = {'GH.dat','HN.dat','NG.dat','GP.dat','PN.dat'};
add_lab= {'N','P','G','H','P'};
add_dat= {'PN.dat','PG.dat','GH.dat','HP.dat'};
% added PG and HP, all others are just connectors

if nargin>0
    datasets = {datasets{:},add_dat{:}};
    labels   = {labels{:},add_lab{2:end}};
end

calc_arr = repmat(IX_dataset_2d(),numel(datasets),1);
q_cen = zeros(3,numel(datasets));
for i=1:numel(calc_arr)
    [calc_arr(i),q_cen(:,i)] = read_kun(datasets{i});
    calc_arr(i).title = [labels{i},labels{i+1}];
end

spaghetti_plot(calc_arr,'labels',labels);
%spaghetti_plot(calc_arr);

