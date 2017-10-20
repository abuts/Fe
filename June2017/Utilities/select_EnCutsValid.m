en=125:5:250;
dir = {'100','110','111'};
filebase = 'Fe_ei401';
root_folder = fileparts(fileparts(mfilename('fullpath')));
source_folder = fullfile(root_folder,'Jvar_All8Braggs');
targ_folder   = fullfile(root_folder,'Jvar_All8Braggs_SelectedCuts');

for i=1:numel(en)
    for j=1:numel(dir)
        fn = sprintf('EnCuts_%s_dE%d_dir_!%s!.mat',filebase,en(i),dir{j});
        source = fullfile(source_folder,fn);
        if ~(exist(source,'file') == 2)
            continue
        end
        [ds,fhh] = plot_EnCuts(source,'-keep_fig');
        fhh = reviewPictures(fhh);
        valid = fhh.get_valid_ind();
        
        dss = ds.select_fitpar(valid);
        target = fullfile(targ_folder,fn);
        dss.save(target);
        fhh.close_all();
    end
end



