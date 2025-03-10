%%=============================================================================
%       Calculate and remove background for Ei=800 meV
% =============================================================================
% Get access to sqw file for the Ei=800meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src800 =fullfile(sqw_dir,'Fe_ei800_align.sqw');
target = fullfile(sqw_dir,'Fe_ei800_no_bg_1D.sqw');
if ~isa('src800','var') || ~isa(src800,'sqw')
    src800 = sqw(data_src800);
end

bg_file = 'w2_800_meV_bg.mat';
if ~isfile(bg_file)
    proj800 = kf_sphere_proj();
    w2_8 = cut_sqw(src800,proj800,[0,21],[0,0.2,80],[-180,180],5,'-nopix');
    save(bg_file,"w2_8");
else
    load(bg_file);
end
w1_8 = cut(w2_8,[0,80],[-20,5,700]);
%%{
plot(w2_8);
lz 0 1
keep_figure;
ds(w2_8)
lz 0 1
keep_figure;

plot(w1_8);
keep_figure;
%}

x1 = w2_8.p{1};
x2 = w2_8.p{2};
x1 = 0.5*(x1(1:end-1)+x1(2:end));
x2 = 0.5*(x2(1:end-1)+x2(2:end));

% F = griddedInterpolant({x1,x2},w2_8.s);
% sqw800_no_bg = sqw_op(src800,@remove_background,{w2_8,F},'outfile',target);

x1=w1_8.p{1};
x1 = 0.5*(x1(1:end-1)+x1(2:end));
F1 = griddedInterpolant(x1,w1_8.s);
sqw800_1Dno_bg = sqw_op(src800,@remove_background1D,{w1_8,F1},'outfile',target);
