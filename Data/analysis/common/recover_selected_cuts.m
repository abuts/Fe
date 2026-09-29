function [cut_struc,fit_cuts_file] = recover_selected_cuts(cut_struc_name,cuts_filepath)
%Helper function to restore cuts for specific direction.
%
% Reduce typing in scripts
if ~exist('cuts_filepath','var')
    cuts_filepath = 'e:\SHARE\Fe\Data\analysis\06_fit_with_J0\sym4D_cutsAndFits\';
end


try
    cut_struc = evalin('base',cut_struc_name);
    return
catch Err
    if ~strcmp(Err.identifier,'MATLAB:UndefinedFunction')
        rethrow(Err);
    end
end
fit_cuts_file  = fullfile(cuts_filepath,[cut_struc_name,'.mat']);
if isfile(fit_cuts_file)
    ld = load(fit_cuts_file);
    if isfield(ld,struc_name)
        cut_struc  = ld.(struc_name);
    else % old cut2fit data
        fn = fieldnames(ld);
        cut_struc = ld.(fn{1}); % Assign the first field to cut_struc
    end
else
    cut_struc  = [];
end