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
if numel(bragg) == 1
    bragg_name = ['[', num2str(bragg),']'];
else
    bragg_name = caption(bragg);
end
if numel(direction) == 1
    dir_name = ['[', num2str(direction),']'];
elseif ischar(direction)
    if direction(1)~='['
        dir_name =['[',direction,']'];
    else
        dir_name = direction;
    end
else
    dir_name  = caption(direction);
end

name = [prefix,fname,'_bragg_',bragg_name,'_dir_',dir_name];
