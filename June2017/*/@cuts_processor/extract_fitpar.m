function [en_list,S,S_err,gamma,gamma_err] = extract_fitpar(obj,direction,en_list)
% Extract appropriate spin wave parameters from the fitted data and
% input metadata
if ~exist('en_list','var')
    range = obj.e_range;
    en_list = range(1):5:range(2);
end

n_en = numel(en_list);
S = zeros(n_en,1)*nan;
S_err = zeros(n_en,1)*nan;
gamma = zeros(n_en,1)*nan;
gamma_err = zeros(n_en,1)*nan;

cut_dir_id = direction_id(direction);
for i=1:n_en
    en = en_list(i);
    bind_id = [num2str(en),cut_dir_id];
    if obj.equal_cuts_map.isKey(bind_id)
        binds = obj.equal_cuts_map(bind_id);
        n_par = binds{1};
        fitpar_array = obj.fitpar.p{n_par};
        fitpar_err   = obj.fitpar.sig{n_par};
        S(i) = fitpar_array(4);
        S_err(i) = fitpar_err(4);
        gamma(i) = abs(fitpar_array(3));
        gamma_err(i) = fitpar_err(3);    
    end
end
valid = ~isnan(S);
en_list = en_list(valid);
S       = S(valid);
S_err   = S_err(valid);
gamma   = gamma(valid);
gamma_err= gamma_err(valid);

