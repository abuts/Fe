function fe2018_off(varargin)

if nargin>0
    this_path = varargin{1};
else
    this_path = fileparts(mfilename('fullpath'));
end

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
rmpath(this_path);
rmpath(util_path);
rmpath(dft_path);
rmpath(cut1_path);
rmpath(cut2_path);
rmpath(cut3_path);
rmpath(cheby_path);
