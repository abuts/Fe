function [calc_arr,q_bg] = plot_spagetti_Kun(varargin)
labels   = {'H','P',' \Gamma','H','N',' \Gamma','P','N'};
datasets = {'HP.dat','PG.dat','GH.dat','HN.dat','NG.dat','GP.dat','PN.dat'};

calc_arr = repmat(IX_dataset_2d(),numel(datasets),1);
q_bg = zeros(3,numel(datasets));
for i=1:numel(calc_arr)
    [calc_arr(i),q_bg(:,i)] = read_kun(datasets{i},true);
    calc_arr(i).title = [labels{i},labels{i+1}];
end

spaghetti_plot(calc_arr,'labels',labels);
%spaghetti_plot(calc_arr);

