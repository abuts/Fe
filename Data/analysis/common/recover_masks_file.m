function cut_struc = recover_masks_file(struc_name,fit_cuts_file_path)
%RECOVER_CUTS_2FIT:  check if provided cuts to fit file containing selected
%cuts and additional information for fitting exist and load this file. 
% Return information stored in the file
% if file not exist, return just empty structure to use for storing fit
% information. 
%
if ~exist('fit_cuts_file_path','var')
    fit_cuts_file_path = 'e:\SHARE\Fe\Data\analysis\06_fit_with_J0\sym4D_cutsAndFits\';
end
try
   cut_struc = evalin('base',struc_name);
   return
catch Err
    if ~strcmp(Err.identifier,'MATLAB:UndefinedFunction')
        rethrow(Err);
    end
end
fit_cuts_file = fullfile(fit_cuts_file_path,[struc_name,'.mat']);
if isfile(fit_cuts_file)
    ld = load(fit_cuts_file);
    if isfield(ld,struc_name)
        cut_struc  = ld.(struc_name);
    else % old cut2fit data
        fn = fieldnames(ld);
        cut_struc = ld.(fn{1}); % Assign the first field to cut_struc
    end
else
    cut_struc  = struct();
end