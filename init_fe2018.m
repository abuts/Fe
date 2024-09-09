dft_path = fileparts(which('disp_dft_kun4D'));
if ~isempty(dft_path)
    old_path = fileparts(fileparts(dft_path));
    fe2018_off(old_path);
end

this_path = fileparts(mfilename('fullpath'));
dft_path = fullfile(this_path,'Data','DFT');
cut1_path = fullfile(this_path,'2017June');
cut2_path = fullfile(this_path,'2018Dec');
cut3_path = fullfile(this_path,'2020April');
util_path  = fullfile(this_path,'2017June','Utilities');
cheby_path =fullfile(this_path,'Data','chebfun-master');

%tf_path = fullfile(hor_path,'_work','TGP_work');
%cd(tf_path);
%test_tobyfit_init(2);
%cd(this_path);
addpath(this_path);
addpath(util_path);
addpath(dft_path);
addpath(cut1_path);
addpath(cut2_path);
addpath(cut3_path);
addpath(cheby_path);
