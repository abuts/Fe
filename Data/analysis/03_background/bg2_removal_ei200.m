%%=============================================================================
%       Calculate and remove background for Ei=200 meV
% =============================================================================
% Get access to sqw file for the Ei=200meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src200 =fullfile(sqw_dir,'Fe_ei200_no_bg2D.sqw');
target = fullfile(sqw_dir,'Fe_ei200_all_bg_4D_reducedBZ_no_ff.sqw');
if ~exist("src200","var") || ~isa(src200,'sqw')
    src200 = sqw(data_src200);
end
alatt = src200.data.alatt;
angdeg= src200.data.angdeg;
rlu = 2*pi./alatt;
r_cut2 = (3.5*rlu(1))^2;
old_range = src200.data.axes.get_cut_range();
del = 0.05;
zoneBins = [-del,0.05,1+del];
e_bins = old_range{4};
cut_range = {zoneBins *rlu(1),zoneBins*rlu(2),zoneBins*rlu(3),[-15,2,200]};


bg_file = 'w4Bz_200meV_bg.mat';
if ~isfile(bg_file)
    sqw200meV_Bz_bg = sqw_op_bin_pixels(src200, @build_bz_background, {r_cut2,rlu},cut_range{:},'-nopix');
    sqw200meV_Bz_bg.filename = 'sqw200meV_Bz_bg';
    save(bg_file,'sqw200meV_Bz_bg');
else
    load(bg_file);
end

%{
w2bz200_100bg = cut(sqw200meV_Bz_bg,[],[],2.209*[-0.1,0.1],[100-5,100+5]);
plot(w2bz200_100bg);lz 0 1; keep_figure;

w1bz200_dEbg = cut(sqw200meV_Bz_bg,2.209*[0,2],2.209*[0,2],2.209*[0,2],[]);
plot(w1bz200_dEbg);
keep_figure;
%}

if isfile(target)
    sqw200_no_bg = sqw(target);
else
    %x2 = w2_4.p{2};
    %x1 = axis_centerpoints(w1bz400_dEbg ,1);
    %x2 = axis_centerpoints(w1bz400_dEbg ,2);
    avBg = smooth(sqw200meV_Bz_bg,4,'hat');
    x1 = axis_centerpoints(avBg ,1);
    x2 = axis_centerpoints(avBg ,2);
    x3 = axis_centerpoints(avBg ,3);
    x4 = axis_centerpoints(avBg ,4);
    F = griddedInterpolant({x1,x2,x3,x4},avBg.s,'linear','none');
    mi = MagneticIons('Fe0');
    fJi = mi.get_fomFactor_fh();
    sqw200_no_bg = sqw_op_bin_pixels(src200,@remove_background_bz0,{F,rlu,r_cut2,fJi},cut_range{:},'outfile',target);
end

%x1=w1_8.p{1};
%x1 = 0.5*(x1(1:end-1)+x1(2:end));
%F1 = griddedInterpolant(x1,w1_8.s);
%sqw800_1Dno_bg = sqw_op(src800,@remove_background1D,{w1_8,F1},'outfile',target);

w2Bg = cut(src200,line_proj,0.04,0.04,[-0.1,0.1],[-10,10],'-nopix');
plot(w2Bg);lz 0 5;keep_figure

w2noBg = cut(sqw200_no_bg,line_proj,0.005,0.005,[-0.1,0.1],[-10,10],'-nopix');
plot(w2noBg);lz 0 100; keep_figure

q1_range = [0,0.005,1];
q2_range = [-0.1,0.1];
q3_range = [-0.1,0.1];
dE_range = [-10,1,165];

[~,name_base] = fileparts(target);
cuts_file_name = ['all_cuts',name_base];
cuts_file = [cuts_file_name,'.mat'];
if isfile(cuts_file)
    fprintf("*** loading resulting cuts from file: %s\n",cuts_file_name);    
    load(cuts_file);
    intensity= [0,1];
    direction = all_cuts.keys;
    fc_final=fig_spread();
    for i=1:numel(direction)
        out_obj = all_cuts(direction{i});
        fh = plot(out_obj);  lz(intensity(1),intensity(2)); keep_figure; 
        fc_final= fc_final.place_fig(fh);
    end    
else
    [all_cuts,all_proj] = gen_spagetty_fcc(sqw200_no_bg,q1_range,q2_range,q3_range,dE_range, ...
        name_base,sqw_dir,false,true);
    fprintf("*** saving resulting cuts to file: %s\n",cuts_file_name);
    save(cuts_file_name,"all_cuts","-v7.3");
end
%--------------------------------------------------------------------------
%plot_unchanged_fcc(src200,all_proj,[-2,0.04,6],q2_range,q3_range,dE_range);
%--------------------------------------------------------------------------
% w2Bg300 = cut(src200,line_proj,0.04,0.04,[-0.1,0.1],[300,320],'-nopix');
% plot(w2Bg300)
% lz 0 0.1
% keep_figure
% w2qEnoBg300 = cut(sqw200_no_bg,line_proj,0.01,0.01,[-0.1,0.1],[300,320],'-nopix');
% plot(w2qEnoBg300)
% lz 0 1
% keep_figure
%
% w2Bg150 = cut(src200,line_proj,0.04,0.04,[-0.1,0.1],[150,170],'-nopix');
% plot(w2Bg150); lz 0 0.5; keep_figure
%
% w2qEnoBg150 = cut(sqw200_no_bg,line_proj,0.01,0.01,[-0.1,0.1],[150,170],'-nopix');
% plot(w2qEnoBg150)
% lz 0 0.5
% keep_figure

function cpa = axis_centerpoints(ds,n_axis)
xi = ds.p{n_axis};
cpa = 0.5*(xi(1:end-1)+xi(2:end));
end

