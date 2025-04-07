%%=============================================================================
%       Calculate and remove background for Ei=1400 meV
% =============================================================================
% Get access to sqw file for the Ei=1400meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src1400 =fullfile(sqw_dir,'Fe_ei1400_align.sqw'); % it is aligned and generated with alignment data
target = fullfile(sqw_dir,'Fe_ei1400_no_bg_2D.sqw');
if ~isa('src1400','var') || ~isa(src1400,'sqw')
    src1400 = sqw(data_src1400);
end

bg_file = 'w2_1400_meV_bg.mat';
if ~isfile(bg_file)
    proj1400 = kf_sphere_proj();
    proj1400.disable_pix_preselection = true;
    w2_14 = cut_sqw(src1400,proj1400,[0,30],[0,0.2,70],[-180,180],4,'-nopix');
    save(bg_file,'w2_14');
else
    load(bg_file);
end
w1_14 = cut(w2_14,[0,70],[-20,5,800]);
%%{
plot(w2_14);
lz 0 4
keep_figure;
ds(w2_14)
lz 0 4
keep_figure;

plot(w1_14);
keep_figure;
%}

if isfile(target)
    sqw1400_no_bg = sqw(target);
else
    x1 = w2_14.p{1};
    x2 = w2_14.p{2};
    x1 = 0.5*(x1(1:end-1)+x1(2:end));
    x2 = 0.5*(x2(1:end-1)+x2(2:end));

    F = griddedInterpolant({x1,x2},w2_14.s);
    sqw1400_no_bg = sqw_op(src1400,@remove_background,{w2_14,F},'outfile',target);
end

%x1=w1_8.p{1};
%x1 = 0.5*(x1(1:end-1)+x1(2:end));
%F1 = griddedInterpolant(x1,w1_8.s);
%sqw800_1Dno_bg = sqw_op(src800,@remove_background1D,{w1_8,F1},'outfile',target);

w2Bg = cut(src1400,line_proj,0.04,0.04,[-0.1,0.1],[-10,10],'-nopix');
plot(w2Bg)
lz 0 5
keep_figure
w2noBg = cut(sqw1400_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[-10,10],'-nopix');
plot(w2noBg)
lz 0 5
keep_figure
prj = line_proj([1,1,0],[-1,1,0]);
w2qEBg = cut(src1400,prj,[-2,0.04,6],[-0.1,0.1],[-0.1,0.1],[-10,5,800],'-nopix');
plot(w2qEBg )
lz 0 1
keep_figure
w2qEnoBg = cut(sqw1400_no_bg,prj,[-2,0.04,6],[-0.1,0.1],[-0.1,0.1],[-10,5,800],'-nopix');
plot(w2qEnoBg)
lz 0 1
keep_figure

w2Bg300 = cut(src1400,line_proj,0.04,0.04,[-0.1,0.1],[300,320],'-nopix');
plot(w2Bg300)
lz 0 0.1
keep_figure
w2qEnoBg300 = cut(sqw1400_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[300,320],'-nopix');
plot(w2qEnoBg300)
lz 0 0.1
keep_figure

w2Bg150 = cut(src400,line_proj,0.04,0.04,[-0.1,0.1],[150,170],'-nopix');
plot(w2Bg150)
lz 0 0.5
keep_figure
w2qEnoBg150 = cut(sqw1400_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[150,170],'-nopix');
plot(w2qEnoBg150)
lz 0 0.5
keep_figure

