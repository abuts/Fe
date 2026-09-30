function [cut_struc,fit_cuts_file] = recover_selected_cuts(cut_struc_name,cuts_filepath)
%Helper function to restore cuts for specific direction.
%
% Reduce typing in scripts
if ~exist('cuts_filepath','var')
    cuts_filepath = 'e:\SHARE\Fe\Data\analysis\07_fit_with_multicut_allJ\sel_cuts';
end

fit_cuts_file  = fullfile(cuts_filepath,[cut_struc_name,'.mat']);
try
    cut_struc = evalin('base',cut_struc_name);
    cut_struc = check_res_type(cut_struc ,cut_struc_name);
    return
catch Err
    if ~strcmp(Err.identifier,'MATLAB:UndefinedFunction')
        rethrow(Err);
    end
end

if isfile(fit_cuts_file)
    ld = load(fit_cuts_file);
    if isfield(ld,cut_struc_name)
        cut_struc  = ld.(cut_struc_name);
        cut_struc = check_res_type(cut_struc ,cut_struc_name);
    else % old cut2fit data or cuts
        fn = fieldnames(ld);
        not_data_name = cellfun(@(x)~strcmp(x,'data_name'),fn);
        fn = fn(not_data_name);
        cut_struc = ld.(fn{1}); % Assign the first field to cut_struc
        cut_struc = check_res_type(cut_struc ,cut_struc_name);
    end
else
    cut_struc  = struct('data_name',cut_struc_name);
end
end

function struc = check_res_type(struc,var_name)
if isfield(struc,'data_name')
    if ~strcmp(struc.data_name,var_name)
        error('Recoverting inconsistent structure: %s for variable: %s', ...
            struc.data_name,var_name);
    end
else
    struc.data_name = var_name;
end
end