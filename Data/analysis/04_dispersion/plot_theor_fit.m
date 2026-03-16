
if ~exist('theor_fit_map_S','var')
    files = containers.Map('KeyType','char','ValueType','any');
    files('GH') = {'LDA_fit_2D_dirGH_dE8.mat','\n'};
    files('GN') = {'LDA_fit_2D_dirNG_dE8.mat','\n'};
    files('GP') = {'LDA_fit_2D_dirGP_dE8.mat'};

    theor_fit_map_S = containers.Map('KeyType','char','ValueType','any');
    theor_fit_map_gamma = containers.Map('KeyType','char','ValueType','any');
    theor_fit_map_J0 = containers.Map('KeyType','char','ValueType','any');

    for dir = string(files.keys)
        filenames = files(dir);
        resS = cell(1,numel(filenames));
        resG = cell(1,numel(filenames));
        resJ = cell(1,numel(filenames));
        for i=1:numel(filenames)
            filename = filenames{i};
            [~,~,fe] = fileparts(filename);
            if isempty(fe); continue; end
            ld = load(filename);
            resS{i} = ld.fit_res.S;
            resG{i} = ld.fit_res.gamma;
            resJ{i} = ld.fit_res.J0;
        end
        theor_fit_map_S(dir) = resS;
        theor_fit_map_gamma(dir) = resG;
        theor_fit_map_J0(dir) = resJ;
    end
end
% input data names:
inp_files = files.values;
inp_files = [inp_files{:}];
title = {''}; n_cell = 1;
for i=1:numel(inp_files)
    file = inp_files{i};
    if strcmp(file,'\n')        
        n_cell = n_cell+1;
        title{n_cell} = '';
    else
        file = strrep(file,'.mat',';');
        file = strrep(file,'_','\_');        
        title{n_cell} = [title{n_cell},file];
    end
end

plot_results(theor_fit_map_S,title);
plot_results(theor_fit_map_gamma,title);
plot_results(theor_fit_map_J0,title);

function plot_results(res_map,sources_info)
colors = containers.Map({'GH','GN','GP'},{'r','g','b'});
keys = res_map.keys;
nk = numel(keys);
plot_h = cell(1,nk);
for i = 1:nk
    dir = keys{i};
    acolor(colors(dir));
    res= res_map(dir);
    [~,axh,plots] = pd([res{:}]);
    plot_h{i} = plots(1);
end
legend([plot_h{:}],keys)
tit = axh.Title;
tit.String = {tit.String{1},sources_info{:}};
axh.Title = tit;
keep_figure;
end
