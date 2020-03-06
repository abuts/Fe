dft_path = fileparts(which('disp_dft_kun4D'));
if ~isempty(dft_path)
    old_path = fileparts(fileparts(dft_path));
    fe2018_off(old_path);
end

this_path = fileparts(mfilename('fullpath'));
dft_path = fullfile(this_path,'Data','DFT');
cut_path = fullfile(this_path,'2017June');
util_path  = fullfile(this_path,'2017June','Utilities');
cheby_path =fullfile(this_path,'Data','chebfun-master');

%tf_path = fullfile(hor_path,'_work','TGP_work');
%cd(tf_path);
%test_tobyfit_init(2);
%cd(this_path);
addpath(this_path);
addpath(util_path);
addpath(dft_path);
addpath(cut_path);
addpath(cheby_path);
