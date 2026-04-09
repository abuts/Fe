% list of pannels to draw
pannels = {'GH_100_data.mat',...
    'HN_010_0p50p50_data.mat',...
    'NG_110_data.mat',...
    'GP_0p50p50p5_data.mat',...
    'PN_0p50p50p5_0p50p50_data_T1.mat' };
n_pannels = numel(pannels);
s_names = {'GH','HN','NG','GP','PN'};


if ~exist('all_data','var')
    dnd_data = repmat(d2d(),1,n_pannels);
    all_data = repmat(struct('combined_ds',[],'data_ranges',[]),1,n_pannels);
    for i=1:n_pannels
        ld = load(pannels{i});
        all_data(i).combined_ds = ld.pan_data.combined_ds;
        all_data(i).data_ranges = ld.pan_data.data_ranges;
    end
    for i=1:n_pannels
        dnd_data(i) = all_data(i).combined_ds.data;
    end

end
labels = {'G','H','N','G','P','N'};
[pl,~,fg,ah] = spaghetti_plot(dnd_data,'labels',labels);
lz 0 1;
pan0 = zeros(1,n_pannels+1);
all_x = cell(1,n_pannels);
all_y = cell(1,n_pannels);
for i=1:n_pannels
    x_range = min_max(0.5*(pl(i).x(1:end-1)+pl(i).x(2:end)));
    pan0(i+1) = pan0(i)+x_range(2);
    all_y{i} = all_data(i).data_ranges(2,:);
    all_x{i} = repmat([pan0(i);pan0(i+1)],1,numel(all_y{i}));
    all_y{i} = [all_y{i};all_y{i}];    
end
ax = [all_x{:}]; ay = [all_y{:}];
line(ah,ax,ay,'Color','red','LineStyle','--');
keep_figure;