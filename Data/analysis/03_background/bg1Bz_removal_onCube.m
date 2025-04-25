%%=============================================================================
%       Calculate and remove background for an qubic test dataset Ei=400 meV
% =============================================================================
root_dir = fileparts(mfilename("fullpath"));
source = fullfile(root_dir,'sqw_cubeTestObj.sqw');
target = fullfile(root_dir,'sqw_cubeTestObj_no_bg.sqw');

if isfile(source)
    if ~exist('sqw_4d_mobj','var')
        sqw_4d_mobj = sqw(source);
    end
    alatt = sqw_4d_mobj.data.alatt;
    angdeg = sqw_4d_mobj.data.angdeg;
else
    alatt = [2.84,2.84,2.84];
    angdeg = [90,90,90];
    ab = line_axes('nbins_all_dims',[120,120,40,62],'img_range',[-4,-4,-2,-10;8,8,2,300]);
    lp = line_proj([1,0,0],[0,1,0],'type','aaa','alatt',alatt,'angdeg',angdeg);

    sqw_4d_mobj = sqw.generate_cube_sqw(ab,lp, ...
        @sqw_bcc_hfm_model,[100,50,0.5,40,1]);
    w2Or0 = cut(sqw_4d_mobj,[],[],[-0.1,0.1],[-5,5]);
    plot(w2Or0);
    w2Or100 = cut(sqw_4d_mobj,[],[],[-0.1,0.1],[100-5,100+5]);
    plot(w2Or100);
    w2Or200 = cut(sqw_4d_mobj,[],[],[-0.1,0.1],[200-5,200+5]);
    plot(w2Or200);
    save(sqw_4d_mobj,source);
end

bg_file = 'w4_WSBz_Cube_bg.mat';
if ~isfile(bg_file)
    rlu = 2*pi./alatt;
    r_cut2 = -1;%(2*rlu(1))^2;
    orng = sqw_4d_mobj.data.img_range;
    old_bins = sqw_4d_mobj.data.axes.get_cut_range();
    proj = line_proj([1/2,1/2,0],[0,1,0],[1/2,1/2,1/2],'nonorthogonal',true,'type','aaa','alatt',alatt,'angdeg',angdeg);
    % build manual transformation: transform CC vector into coordinate
    % system build on WS cell
    BM = proj.bmatrix(3);
    WS_cell = [1/2,1/2,0;0,1,0;1/2,1/2,1/2]'; % Wigner-Seitz cell for FCC in hkl
    test_vec = [eye(3),WS_cell];

    wc = BM*WS_cell;
    norm_vec = proj.transform_pix_to_img(wc);
    norm_vec = diag(norm_vec);

    wcN = [norm_vec(1),norm_vec(2),norm_vec(3)];
    wct = rotz(-45)*(wc./repmat(wcN,3,1));
    %tcm = mtimesx_horace(wct,test_vec);
    tcm = wct*test_vec;
    % projection which provides the same transformation:
    uu= ubmat_proj('u_to_rlu',inv(wct*BM),'img_scales',ones(3,1),'alatt',alatt,'angdeg',angdeg);
    tcm0 = uu.transform_pix_to_img(test_vec);
    %
    %WS_ranges = proj.transform_hkl_to_img(WS_cell);
    WS_ranges = uu.transform_hkl_to_img(WS_cell);    
    %max_range = [norm(WS_ranges(:,1)) ,norm(WS_ranges(:,2)),norm(WS_ranges(:,3))];
    max_range = wcN;    
    tc = proj.transform_pix_to_img(test_vec);
    edg = -0.05;
    bin_range = {[edg,0.04,max_range(1)-edg],[edg,0.1,max_range(2)-edg ],[edg,0.04,max_range(3)-edg],old_bins{4}};

    msqw400meV_Bz_bg = sqw_op_bin_pixels(sqw_4d_mobj, @build_WigSeitz_background, {r_cut2,max_range},proj,bin_range{:},'-nopix');
    msqw400meV_Bz_bg.filename = 'modelCubeWSBZ_sqw400meV_bg';
    %save(bg_file,'msqw400meV_Bz_bg','max_range');
else
    load(bg_file);
end


%%{
w2bz400_0fg = cut(msqw400meV_Bz_bg,[],[],[-0.05,0.05],[-5,+5]);
plot(w2bz400_0fg);
keep_figure;

w2bz400_100fg = cut(msqw400meV_Bz_bg,[],[],[-0.05,0.05],[100-5,100+5]);
plot(w2bz400_100fg);
lz 1 3.2
keep_figure;

mw1bz400_dEbg = cut(msqw400meV_Bz_bg,2.209*[0,2],2.209*[0,2],2.209*[0,2],[]);
plot(mw1bz400_dEbg);
keep_figure;
%}

if isfile(target)
    msqw400_no_bg = sqw(target);
else
    %x2 = w2_4.p{2};
    %x1 = axis_centerpoints(mw1bz400_dEbg ,1);
    %x2 = axis_centerpoints(w1bz400_dEbg ,2);
    avBg = msqw400meV_Bz_bg;
    x1 = axis_centerpoints(avBg ,1);
    x2 = axis_centerpoints(avBg ,2);
    x3 = axis_centerpoints(avBg ,3);
    x4 = axis_centerpoints(avBg ,4);
    F = griddedInterpolant({x1,x2,x3,x4},avBg.s,'linear','none');

    msqw400_no_bg = sqw_op(sqw_4d_mobj,@remove_background,{msqw400meV_Bz_bg,F,max_range},'outfile',target);
end

%x1=w1_8.p{1};
%x1 = 0.5*(x1(1:end-1)+x1(2:end));
%F1 = griddedInterpolant(x1,w1_8.s);
%sqw800_1Dno_bg = sqw_op(src800,@remove_background1D,{w1_8,F1},'outfile',target);

w2Bg = cut(sqw_4d_mobj,line_proj,0.1,0.1,[-0.1,0.1],[-10,10],'-nopix');
plot(w2Bg)
lz 1 3.2
keep_figure
w2noBg = cut(msqw400_no_bg,line_proj,0.1,0.1,[-0.1,0.1],[-10,10],'-nopix');
plot(w2noBg)
lz 0 3.2
keep_figure
prj = line_proj([1,1,0],[-1,1,0]);
w2qEBg = cut(sqw_4d_mobj,prj,0.1,[-0.1,0.1],[-0.1,0.1],[],'-nopix');
plot(w2qEBg )
lz 0 3.2
keep_figure
w2qEnoBg = cut(msqw400_no_bg,prj,0.1,[-0.1,0.1],[-0.1,0.1],[],'-nopix');
plot(w2qEnoBg)
lz 0 3.2
keep_figure

w2Bg300 = cut(sqw_4d_mobj,line_proj,0.1,0.1,[-0.1,0.1],[180,200],'-nopix');
plot(w2Bg300)
lz 0 3.2
keep_figure
w2qEnoBg300 = cut(msqw400_no_bg,line_proj,0.1,0.1,[-0.1,0.1],[180,200],'-nopix');
plot(w2qEnoBg300)
lz 0 3.2
keep_figure

w2Bg150 = cut(sqw_4d_mobj,line_proj,0.1,0.1,[-0.1,0.1],[150,170],'-nopix');
plot(w2Bg150)
lz 0 3.2
keep_figure
w2qEnoBg150 = cut(msqw400_no_bg,line_proj,0.1,0.1,[-0.1,0.1],[150,170],'-nopix');
plot(w2qEnoBg150)
lz 0 3.2
keep_figure

function cpa = axis_centerpoints(ds,n_axis)
xi = ds.p{n_axis};
cpa = 0.5*(xi(1:end-1)+xi(2:end));
end