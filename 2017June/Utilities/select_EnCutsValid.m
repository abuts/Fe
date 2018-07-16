% script helper to look through range of constant energy cuts, 
% generated during the fitting using cut_processor or cut_le_processor and
% selecting the nice cuts for future reprocessing using the same classes.

en=50:5:100;
% cuts directions
dir = {'100','110','111'};
filebase = 'Fe_ei787';
root_folder = fileparts(fileparts(mfilename('fullpath')));
% where the source cuts are located
source_folder = fullfile(root_folder,'J0varEi800');
% where to write the 
targ_folder   = fullfile(root_folder,'J0varEi800_selected_cuts');

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


