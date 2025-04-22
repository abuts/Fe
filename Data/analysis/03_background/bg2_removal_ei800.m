%%=============================================================================
%       Calculate and remove background for Ei=800 meV
% =============================================================================
% Get access to sqw file for the Ei=800meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src800 =fullfile(sqw_dir,'Fe_ei800_align.sqw');
target = fullfile(sqw_dir,'Fe_ei800_no_bg_4D.sqw');
if ~isa('src800','var') || ~isa(src800,'sqw')
    src800 = sqw(data_src800);
end

bg_file = 'Bz4D_800meV_fg.mat';
if ~isfile(bg_file)
    alatt= src800.data.alatt;
    rlu = 2*pi./alatt;
    r_cut2 = (3*rlu(1))^2;
    cutter = PageOp_sqw_binning();
    old_range = src800.data.img_range;
    cutter.new_binning = [40,40,40,100];
    cutter.new_range = [0,0,0,old_range(1,4);2*rlu(1),2*rlu(2),2*rlu(3),old_range(2,4)];
    sqw800meV_Bz_fg = sqw_op(src800, @build_bz_background, r_cut2,cutter,'-nopix');
    sqw800meV_Bz_fg.filename = 'sqw800meV_Bz_fg';    
    save(bg_file,'sqw800meV_Bz_fg');
else
    load(bg_file);
end

w1bz800_dEbg = cut(sqw800meV_Bz_fg,2.209*[0,2],2.209*[0,2],2.209*[0,2],[]);
%%{
w2bz800_100bg = cut(sqw800meV_Bz_fg,[],[],2.209*[-0.1,0.1],[100-5,100+5]);
plot(w2bz800_100bg);
lx 0 4.41;ly 0 4.41;lz 0 1;
grid on
keep_figure;

w2bz1400_100bgs = smooth(w2bz800_100bg,4,'hat');
plot(w2bz1400_100bgs);
lx 0 4.41;ly 0 4.41;lz 0 1;
grid on
keep_figure;

w2bz800_0bg = cut(sqw800meV_Bz_fg,[],[],2.209*[-0.1,0.1],[300-5,300+5]);
plot(w2bz800_0bg);
lx 0 4.41;ly 0 4.41;lz 0 1;
grid on
keep_figure;

plot(w1bz800_dEbg);
keep_figure;
%}
if isfile(target)
    sqw800_no_bg = sqw(target);
else

    x1 = w1bz800_dEbg.p{1};
    %x2 = w2_4bz.p{2};
    x1 = 0.5*(x1(1:end-1)+x1(2:end));
    %x2 = 0.5*(x2(1:end-1)+x2(2:end));

    %F = griddedInterpolant({x1,x2},w2_4bz.s);
    F = griddedInterpolant(x1,w1bz800_dEbg.s);
    sqw800_no_bg = sqw_op(src800,@remove_background,{sqw800meV_Bz_fg,F},'outfile',target);
end

%x1=w1_8.p{1};
%x1 = 0.5*(x1(1:end-1)+x1(2:end));
%F1 = griddedInterpolant(x1,w1_8.s);
%sqw800_1Dno_bg = sqw_op(src800,@remove_background1D,{w1_8,F1},'outfile',target);

w2Bg = cut(src800,line_proj,0.04,0.04,[-0.1,0.1],[-10,10],'-nopix');
plot(w2Bg)
lz 0 5
keep_figure
w2noBg = cut(sqw800_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[-10,10],'-nopix');
plot(w2noBg)
lz 0 5
keep_figure
prj = line_proj([-1,1,0],[1,1,0]);
w2qEBg = cut(src800,prj,[-2,0.04,6],[-0.1,0.1],[-0.1,0.1],[-10,5,500],'-nopix');
plot(w2qEBg )
lz 0 1
keep_figure
w2qEnoBg = cut(sqw800_no_bg,prj,[-2,0.04,6],[-0.1,0.1],[-0.1,0.1],[-10,5,500],'-nopix');
plot(w2qEnoBg)
lz 0 1
keep_figure

w2Bg300 = cut(src800,line_proj,0.04,0.04,[-0.1,0.1],[300,320],'-nopix');
plot(w2Bg300)
lz 0 0.1
keep_figure
w2qEnoBg300 = cut(sqw800_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[300,320],'-nopix');
plot(w2qEnoBg300)
lz 0 0.1
keep_figure

w2Bg150 = cut(src800,line_proj,0.04,0.04,[-0.1,0.1],[150,170],'-nopix');
plot(w2Bg150)
lz 0 0.5
keep_figure
w2qEnoBg150 = cut(sqw800_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[150,170],'-nopix');
plot(w2qEnoBg150)
lz 0 0.5
keep_figure

