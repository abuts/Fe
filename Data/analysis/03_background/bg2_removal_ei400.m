%%=============================================================================
%       Calculate and remove background for Ei=400 meV
% =============================================================================
% Get access to sqw file for the Ei=400meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src400 =fullfile(sqw_dir,'Fe_ei401_align.sqw');
target = fullfile(sqw_dir,'Fe_ei401_no_bg_4D.sqw');
if ~isa('src400','var') || ~isa(src400,'sqw')
    src400 = sqw(data_src400);
end

bg_file = 'w4Bz_400_meV_bg.mat';
if ~isfile(bg_file)
    alatt= src400.data.alatt;
    r_cut2 = (3*alatt(1))^2;
    cutter = PageOp_sqw_binning();
    old_range = src400.data.img_range;
    cutter.new_binning = [40,40,40,100];
    cutter.new_range = [0,0,0,old_range(1,4);2*alatt(1),2*alatt(2),2*alatt(3),old_range(2,4)];
    sqw400meV_Bz_bg = sqw_op(src400, @build_bz_background, r_cut2,cutter,'-nopix');
    save(bg_file,'sqw400meV_Bz_bg');   
else
    load(bg_file);
end
w2bz400_100bg = cut(sqw400meV_Bz_bg,[],[],2.209*[-0.1,0.1],[100-5,100+5]);

%%{
plot(w2bz400_100bg );
lz 0 4
keep_figure;

ds(w2_4)
lz 0 4
keep_figure;

plot(w1_4);
keep_figure;
%}

if isfile(target)
    sqw400_no_bg = sqw(target);
else
    x1 = w2_4.p{1};
    x2 = w2_4.p{2};
    x1 = 0.5*(x1(1:end-1)+x1(2:end));
    x2 = 0.5*(x2(1:end-1)+x2(2:end));

    F = griddedInterpolant({x1,x2},w2_4.s);
    sqw400_no_bg = sqw_op(src400,@remove_background,{w2_4,F},'outfile',target);
end

%x1=w1_8.p{1};
%x1 = 0.5*(x1(1:end-1)+x1(2:end));
%F1 = griddedInterpolant(x1,w1_8.s);
%sqw800_1Dno_bg = sqw_op(src800,@remove_background1D,{w1_8,F1},'outfile',target);

w2Bg = cut(src400,line_proj,0.04,0.04,[-0.1,0.1],[-10,10],'-nopix');
plot(w2Bg)
lz 0 5
keep_figure
w2noBg = cut(sqw400_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[-10,10],'-nopix');
plot(w2noBg)
lz 0 5
keep_figure
prj = line_proj([1,1,0],[-1,1,0]);
w2qEBg = cut(src400,prj,[-2,0.04,6],[-0.1,0.1],[-0.1,0.1],[-10,2,350],'-nopix');
plot(w2qEBg )
lz 0 1
keep_figure
w2qEnoBg = cut(sqw400_no_bg,prj,[-2,0.04,6],[-0.1,0.1],[-0.1,0.1],[-10,5,350],'-nopix');
plot(w2qEnoBg)
lz 0 1
keep_figure

w2Bg300 = cut(src400,line_proj,0.04,0.04,[-0.1,0.1],[300,320],'-nopix');
plot(w2Bg300)
lz 0 0.1
keep_figure
w2qEnoBg300 = cut(sqw400_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[300,320],'-nopix');
plot(w2qEnoBg300)
lz 0 0.1
keep_figure

w2Bg150 = cut(src400,line_proj,0.04,0.04,[-0.1,0.1],[150,170],'-nopix');
plot(w2Bg150)
lz 0 0.5
keep_figure
w2qEnoBg150 = cut(sqw400_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[150,170],'-nopix');
plot(w2qEnoBg150)
lz 0 0.5
keep_figure

