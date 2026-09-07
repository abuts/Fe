function cut_struc = recover_cuts_2fit(fit_cuts_file,struc_name)
%RECOVER_CUTS_2FIT:  check if provided cuts to fit file containing selected
%cuts and additional information for fitting exist and load this file. 
% Return information stored in the file
% if file not exist, return just empty structure to use for storing fit
% information. 
%

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