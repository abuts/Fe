function [obj,filenames,file_directions,missing_files,missing_dir] = find_initial_cuts(obj,bragg_list,file_list)
% build list of initial cut files for multifitting and check if the files with these names are present
% The initial
%
%
%Return:
% filenames::        list of existign files to read data from.
% file_directions :: list of 3D vectors, defining the direction of a cut. (e.g.
%                    {[1,0,0],[0,1,0],[1,1,1]};
% missing_files   :: list of missing filenames
% missing_dir     :: list of directions for missing cuts
%

br_key = @(bragg)(['[' num2str(bragg(1)) num2str(bragg(2))  num2str(bragg(3)) ']']);
br_folder = @(bragg)(['Br',obj.ind_name(bragg(1)),obj.ind_name(bragg(2)),obj.ind_name(bragg(3))]);
if ~iscell(bragg_list)
    bragg_list = {bragg_list};
end
if ~iscell(file_list)
    file_list = {file_list};
end
obj.bragg_list = bragg_list;
obj.file_list = file_list;

filenames = {};
missing_files = {};
missing_dir = {};
file_directions = {};
for i=1:numel(bragg_list)
    bragg = bragg_list{i};
    cut_name  = br_key(bragg);
    cuts_dir = obj.cuts_dir_list(cut_name);
    for j=1:numel(file_list)
        file = file_list{j};
        for k1=1:numel(cuts_dir)
            direction = cuts_dir{k1};
            data_file = obj.source_cuts_fname_(file,bragg,direction,'TF_');
            file_0 = fullfile(obj.rood_data_folder_,[data_file,'.mat']);
            f_exist = false;
            if exist(file_0,'file') == 2
                filenames = [filenames(:);{file_0}];
                f_exist = true;
                file_directions = [file_directions(:);direction];
            else
                brf = br_folder(bragg);
                file_0 = fullfile(obj.rood_data_folder_,brf,[data_file,'.mat']);
                if exist(file_0,'file') == 2
                    f_exist = true;
                end
            end
            if f_exist
                filenames = [filenames(:);{file_0}];
                file_directions = [file_directions(:);direction];
            else
                missing_files = [missing_files(:);{data_file}];
                missing_dir   = [missing_dir(:);direction];
                %error('file %s does not exist',data_file);
            end
        end
        
    end
end

