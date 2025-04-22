%%=============================================================================
%       Calculate and remove background for Ei=1400 meV
% =============================================================================
% Get access to sqw file for the Ei=1400meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src1400 =fullfile(sqw_dir,'Fe_ei1400_no_bg_2D.sqw'); % it is aligned and generated with alignment data
target = fullfile(sqw_dir,'Fe_ei1400_no_bg_2c4D4Dbg_nos.sqw');
if ~isa('src1400','var') || ~isa(src1400,'sqw')
    src1400 = sqw(data_src1400);
end

bg_file = 'Bz4D_1400meV_bg.mat';
if ~isfile(bg_file)
    alatt= src1400.data.alatt;
    rlu = 2*pi./alatt;
    r_cut2 = (3*rlu(1))^2;
    cutter = PageOp_sqw_binning();
    old_range = src1400.data.img_range;
    cutter.new_binning = [60,60,60,100];
    cutter.new_range = [0,0,0,old_range(1,4);2*rlu(1),2*rlu(2),2*rlu(3),old_range(2,4)];
    sqw1400meV_Bz_bg = sqw_op(src1400, @build_bz_background, r_cut2,cutter,'-nopix');
    sqw800meV_Bz_bg.filename = 'sqw1400meV_BzAndCyl_bg';
    save(bg_file,'sqw1400meV_Bz_bg');

else
    load(bg_file);
end
w1bz1400_dEbg = cut(sqw1400meV_Bz_bg,2.209*[0,2],2.209*[0,2],2.209*[0,2],[]);
%{
w2bz1400_100bg = cut(sqw1400meV_Bz_bg,[],[],2.209*[-0.1,0.1],[100-5,100+5]);
plot(w2bz1400_100bg);
grid on
keep_figure;
w2bz1400_100bgs = smooth(w2bz1400_100bg,4,'hat');
plot(w2bz1400_100bgs);
grid on
keep_figure;

acolor k
plot(w1bz1400_dEbg);
pl(w1bz1400_dEbg);
ly 0 2
grid on
keep_figure;
%}

if isfile(target)
    sqw1400_no_bg = sqw(target);
else
    %x1 = w1bz1400_dEbg.p{1};
    %x2 = w2_14.p{2};
    %x1 = 0.5*(x1(1:end-1)+x1(2:end));
    %x2 = 0.5*(x2(1:end-1)+x2(2:end));

    %F = griddedInterpolant({x1,x2},w2_14.s);
    %F = griddedInterpolant(x1,w1bz1400_dEbg.s);
    %sqw1400_no_bg = sqw_op(src1400,@remove_background,{w1bz1400_dEbg,F},'outfile',target);
    %avBg = smooth(sqw1400meV_Bz_bg,4,'hat');
    avBg = sqw1400meV_Bz_bg;    
    x1 = axis_centerpoints(avBg ,1);
    x2 = axis_centerpoints(avBg ,2);
    x3 = axis_centerpoints(avBg ,3);
    x4 = axis_centerpoints(avBg ,4);    
    F = griddedInterpolant({x1,x2,x3,x4},sqw1400meV_Bz_bg.s);
    sqw1400_no_bg = sqw_op(src1400,@remove_background,{sqw1400meV_Bz_bg,F},'outfile',target);
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

w2Bg150 = cut(sqw1400_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[150,170],'-nopix');
plot(w2Bg150)
lz 0 0.5
keep_figure
w2qEnoBg150 = cut(sqw1400_no_bg,line_proj,0.04,0.04,[-0.1,0.1],[150,170],'-nopix');
plot(w2qEnoBg150)
lz 0 0.5
keep_figure

function cpa = axis_centerpoints(ds,n_axis)
xi = ds.p{n_axis};
cpa = 0.5*(xi(1:end-1)+xi(2:end));
end