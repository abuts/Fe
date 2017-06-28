function fp_data = get_fitpar_vs_en(obj,n_fitpar,direction,en_list)
% get selected fitting parameter dependence on energy
%
% Input :
% n_fitpar  -- number of the parameter to extract
% direction -- the direction of extraction
% en_list   -- if provided, range of energies to extact parameter
%              if not, maximal object's energy range will be used
%
% Output:
% IX_dataset_1d with fitpar as function of energy
%
if ~exist('en_list','var')
    range = obj.e_range;
    en_list = range(1):5:range(2);
end

n_en = numel(en_list);
fp = zeros(n_en,1)*nan;
fp_err = zeros(n_en,1)*nan;

cut_dir_id = direction_id(direction);
for i=1:n_en
    en = en_list(i);
    bind_id = [num2str(en),cut_dir_id];
    if obj.equal_cuts_map.isKey(bind_id)
        binds = obj.equal_cuts_map(bind_id);
        n_par = binds{1};
        fitpar_array = obj.fitpar.p{n_par};
        fitpar_err   = obj.fitpar.sig{n_par};
        fp(i) = fitpar_array(n_fitpar);
        fp_err(i) = fitpar_err(n_fitpar);
    end
end
valid = ~isnan(fp);
en_list = en_list(valid);
fp       = fp(valid);
fp_err   = fp_err(valid);
fp_data = IX_dataset_1d(en_list,fp,fp_err);


