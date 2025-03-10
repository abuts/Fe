%%=============================================================================
%       Calculate and remove background for Ei=200 meV
% =============================================================================
% Get access to sqw file for the Ei=200meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src200 =fullfile(sqw_dir,'Fe_ei200_align.sqw');
target = fullfile(sqw_dir,'Fe_ei200_no_bg2D.sqw');
src200 = sqw(data_src200);


bg_file = 'w2_200_meV_bg.mat';
if ~isfile(bg_file)
    sproj200 = kf_sphere_proj();
    w2_200meV = cut_sqw(src200,sproj200,[0,10],[0,0.4,85],[-180,180],[-20,2,170],'-nopix');
    save(bg_file,"w2_200meV");
else
    load(bg_file);
end
%%{
plot(w2_200meV);
lz 0 1
keep_figure;
ds(w2_200meV )
lz 0 1
keep_figure;
w1_200meV = cut(w2_200meV,[0,85],[-20,2,170]);
plot(w1_200meV);
keep_figure;
%}
if ~isfile(target)
    x1 = w2_200meV.p{1};
    x2 = w2_200meV.p{2};
    x1 = 0.5*(x1(1:end-1)+x1(2:end));
    x2 = 0.5*(x2(1:end-1)+x2(2:end));
    %[x1,x2] = meshgrid(x1,x2);
    F = griddedInterpolant({x1,x2},w2_200meV.s);
    src200_noBb = sqw_op(src200,@remove_background,{w2_200meV,F},'outfile',target);
else
    src200_noBb = sqw(target);    
end

w2Bg = cut(src200,line_proj,0.01,0.01,[-0.1,0.1],[-10,10],'-nopix');
plot(w2Bg)
lz 0 5
keep_figure
w2noBg = cut(src200_noBb,line_proj,0.01,0.01,[-0.1,0.1],[-10,10],'-nopix');
plot(w2noBg)
lz 0 5
keep_figure
prj = line_proj([1,1,0],[-1,1,0]);
w2qEBg = cut(src200,prj,0.01,[-0.1,0.1],[-0.1,0.1],2,'-nopix');
plot(w2qEBg )
lz 0 1
keep_figure
w2qEnoBg = cut(src200_noBb,prj,0.01,[-0.1,0.1],[-0.1,0.1],2,'-nopix');
plot(w2qEnoBg)
lz 0 1
keep_figure

