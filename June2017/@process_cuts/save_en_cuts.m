function obj = save_en_cuts(obj,FileSourceID)
% Save results of energy fitting as range of files, each file containing
% the cuts, contributed to this energy fitting.
% 
% 
if isempty(obj.fits_list) || isempty(obj.fitpar)
    error('PROCESS_CUTS:runtime_error','nothing to save, fit has not been done');
end
file_list = obj.file_list;
used_files = [file_list{:}];
if ~exist('FileSourceID','var')
    FileSourceID = used_files;
end

bragg_list = obj.bragg_list;
if numel(bragg_list) > 1
    bragg_id = '_All_';
else    
    bragg = bragg_list{1};
    bragg_id = ['br_[',obj.ind_name(bragg (1)),obj.ind_name(bragg(2)),obj.ind_name(bragg (3)),']'];
end
fitted_par_id = obj.fitted_par_id;
filename = ['J_fit_',FileSourceID,bragg_id,fitted_par_id];

fitpar = []; % Will extract it from fp_arr1;
bg_params = []; % Will extract it from fp_arr1;
bind_map = obj.equal_cuts_map;
fp_arr1  = obj.fitpar;
save(filename ,'fitpar','bg_params','bragg_list',...
    'file_list','bind_map','fp_arr1');

%   Detailed explanation goes here
keys = obj.equal_cuts_map.keys;
f_en =@(x)(0.5*(x.data.iint(2,3)+x.data.iint(1,3)));
for i=1:numel(keys)
    theKey = keys{i};
    binding = obj.equal_cuts_map(theKey);
    ind = [binding{:}];
    stor = struct();
    cuts_fitpar=struct();
    stor.cut_list = obj.cuts_list(ind);
    stor.w1D_arr1_tf = obj.fits_list(ind);
    cuts_fitpar.p = obj.fitpar.p(ind);
    cuts_fitpar.sig =obj.fitpar.sig(ind);
    cuts_fitpar.bp  = obj.fitpar.bp(ind);
    cuts_fitpar.bsig =obj.fitpar.bsig(ind);
    stor.fp_arr1 = cuts_fitpar;
    stor.es_valid = arrayfun(f_en,stor.cut_list);
    direction_id = regexp(theKey,'[<>]');
    dir_id = theKey(direction_id(1)+1:direction_id(2)-1);
    fn = sprintf('EnCuts_%s_dE%d_dir_!%s!',FileSourceID,stor.es_valid(1),dir_id);
    n_cuts = numel(stor.cut_list);
    
    fld_names = fieldnames(stor);
    save(fn,'-struct','stor',fld_names{:});
    fprintf(' En=%d; Cuts Group N:%d/%d  Consisting of %d Cuts\n',stor.es_valid(1),i,numel(keys),n_cuts);    
    %view_EnCuts(stor);    
end


