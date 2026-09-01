function cut_struc = recover_cuts_2fit(fit_cuts_file,struc_name)
%RECOVER_CUTS_2FIT:  check if provided cuts to fit file containing selected
%cuts and additional information for fitting exist and load this file. 
% Return information stored in the file
% if file not exist, return just empty structure to use for storing fit
% information. 
%

if isfile(fit_cuts_file)
    ld = load(fit_cuts_file);
    cut_struc  = ld.(struc_name);

else
    cut_struc  = struct();
end