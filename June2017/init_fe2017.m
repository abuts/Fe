hor_path = fileparts(which('horace_init.m'));
this_path = fileparts(mfilename('fullpath'));
tf_path = fullfile(hor_path,'_work','TGP_work');
cd(tf_path);
test_tobyfit_init(2);
cd(this_path);
addpath(this_path);
