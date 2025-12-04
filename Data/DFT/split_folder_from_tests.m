function [folder, file, name] = split_folder_from_tests (arg)
% Attempt to split into a folder and mfilename with the form
%   folder/mfile
%   folder/mfile:testname
%
% Returns
%   folder      The name of the folder
%   file        The name of the mfile
%   name        The name of the test. This could be one of
%               - mfile
%               - mfile:testname


% Find occurences of ':'. These could be because the input has a full path on a
% Windows computer, and/or a single test name within a test suite (which is
% demarcated by ':' or '::')
ddot_ind = strfind(arg,':');

% Skip over disk in full path if PC
if ispc && ~isempty(ddot_ind) && numel(arg)>=3 && any(strcmp(arg(2:3),{':\', ':/'}))
    % Begins '*:\' or '*:/' as would be expected if arg has a full Windows path
    ddot_ind = ddot_ind(2:end);     % indices of any remaining ':'
end

% Get test folder and test file name
if ~isempty(ddot_ind)
    % This demarcates a particular test case within the mfile
    full_file = arg(1:ddot_ind(1)-1);
    test_case = arg(ddot_ind(1):end);
else
    full_file = arg;
    test_case = '';
end

[folder, file] = fileparts(full_file);
name = [file, test_case];   % re-append particular test, if present

end