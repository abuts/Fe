function obj = save_en_cuts(obj,FileSourceID,file_preffix)
% Save results of energy fitting as range of files, each file containing
% the cuts, contributed to this energy fitting.
%
%
if isempty(obj.fits_list) || isempty(obj.fitpar)
    error('CUTS_PROCESSOR:runtime_error','nothing to save, fit has not been done');
end
file_list = obj.file_list;
used_files = [file_list{:}];
if ~exist('FileSourceID','var') || isempty(FileSourceID)
    FileSourceID = used_files;
end
if ~exist('file_preffix','var')
    file_preffix = 'J_fit_';
end


bragg_list = obj.bragg_list;
if numel(bragg_list) > 1
    bragg_id = sprintf('_%dBraggs_',numel(bragg_list));
else
    bragg = bragg_list{1};
    bragg_id = ['br_[',cuts_processor.ind_name(bragg (1)),...
        cuts_processor.ind_name(bragg(2)),cuts_processor.ind_name(bragg (3)),']'];
end
fitted_par_id = obj.fitted_par_id;
filename = [file_preffix,FileSourceID,bragg_id,fitted_par_id];

fitpar = obj.fitpar; % Will extract it from fp_arr1 but can be extracted from here;
bg_params = obj.fitpar.bp; % Will extract it from fp_arr1;
bind_map = obj.equal_cuts_map;
fp_arr1  = obj.fitpar;
save(filename ,'fitpar','bg_params','bragg_list',...
    'file_list','bind_map','fp_arr1');

% disable saving energy blocks for the time 
return;

keys = obj.equal_cuts_map.keys;


for i=1:numel(keys)
    theKey = keys{i};
    stor = obj.build_stor_structure_(theKey);
    

    stor.save();
    
    n_cuts = numel(stor.cuts_list);
    fprintf(' En=%d; Cuts Group N:%d/%d  Consisting of %d Cuts\n',stor.cut_energies(1),i,numel(keys),n_cuts);
    %plot_EnCuts(stor);
end


