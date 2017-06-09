function name = rez_name(data_file,bragg,direction)
% function defines the filename used to store intermediate cuts
%
[~,fname] = fileparts(data_file);
caption =@(vector)['[' num2str(vector(1)) num2str(vector(2))  num2str(vector(3)) ']'];
bragg_name = caption(bragg);
dir_name  = caption(direction);

name = ['TF_',fname,'_bragg_',bragg_name,'_dir_',dir_name];
