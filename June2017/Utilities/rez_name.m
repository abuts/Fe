function name = rez_name(data_file,bragg,direction,varargin)
% function defines the filename used to store intermediate cuts
%
if nargin>3
    prefix = varargin{1};
else
    prefix = 'TF_';
    
end
[~,fname] = fileparts(data_file);
caption =@(vector)['[' num2str(vector(1)) num2str(vector(2))  num2str(vector(3)) ']'];
bragg_name = caption(bragg);
dir_name  = caption(direction);

name = [prefix,fname,'_bragg_',bragg_name,'_dir_',dir_name];
