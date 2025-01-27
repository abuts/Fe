%%=============================================================================
%       Calculate and remove background for Ei=200 meV
% =============================================================================
% Get access to sqw file for the Ei=200meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src200 =fullfile(sqw_dir,'Fe_ei200_align.sqw');
target = fullfile(sqw_dir,'Fe_ei200_no_bg.sqw');
data_src200 = sqw(data_src200);


bg_file = 'w2_200_meV_bg.mat';
if ~isfile(bg_file)
    proj200 = kf_sphere_proj(200);
    w2_2 = cut_sqw(data_src200,proj200,[0,10],[0,0.4,85],[-180,180],[-20,2,170],'-nopix');
    save(bg_file,"w2_2");
else
    load(bg_file);
end
%{
plot(w2_2);
lz 0 1
keep_figure;
ds(w2_2)
lz 0 1
keep_figure;
w1_2 = cut(w2_2,[0,85],[-20,2,170]);
plot(w1_2);
keep_figure;
%}
x1 = w2_2.p{1};
x2 = w2_2.p{2};
x1 = 0.5*(x1(1:end-1)+x1(2:end));
x2 = 0.5*(x2(1:end-1)+x2(2:end));
%[x1,x2] = meshgrid(x1,x2);
F = griddedInterpolant({x1,x2},w2_2.s);
sqw2_no_bg = sqw_op(data_src200,@remove_background,{w2_2,F},'outfile',target);
