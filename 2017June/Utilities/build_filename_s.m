function files_list = build_filename_s( file_base,varargin )
% Using file_base and Bragg peak /direction qualifier return the list of
% appropriate file names containing appropriate direction cut file(s)
if nargin == 1
    [~,~,fe]=fileparts(file_base);
    if isempty(fe)
        files_list = {[file_base,'.mat']};
    else
        files_list = {file_base};
    end
    
elseif nargin == 2
    f_base = file_base;
    bragg = varargin{1};
    dir   = {[1,0,0],[0,1,0],[0,0,1],...
        [1,1,0],[1,-1,0],[1,0,1],[1,0,-1],[0,1,1],[0,1,-1],...
        [1,1,1],[1,1,-1],[1,-1,-1],[1,-1,1]};
    in_files = cell(numel(dir),1);
    files_list = cell(numel(in_files),1);
    for i=1:numel(in_files)
        files_list{i} = rez_name(f_base,bragg,dir{i},'TF_');
    end
elseif nargin == 3
    f_base = file_base;
    bragg = varargin{1};
    dir   = varargin{2};
    files_list{1} = rez_name(f_base,bragg,dir,'TF_');
end
