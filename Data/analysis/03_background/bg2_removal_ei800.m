%%=============================================================================
%       Calculate and remove background for Ei=800 meV
% =============================================================================
% Get access to sqw file for the Ei=800meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src800 =fullfile(sqw_dir,'Fe_ei800_align.sqw');
target = fullfile(sqw_dir,'Fe_ei800_no_bg_2D_reducedBZ_no_ff_filt_remove.sqw');
if ~isa('src800','var') || ~isa(src800,'sqw')
    src800 = sqw(data_src800);
end
alatt = src800.data.alatt;
angdeg= src800.data.angdeg;
rlu = 2*pi./alatt;
r_cut2 = (3*rlu(1))^2;
old_range = src800.data.axes.get_cut_range();
del = 0.05;
zoneBins = [-0.5*del,0.05,1+0.5*del];
e_bins = old_range{4};
cut_range = {zoneBins *rlu(1),zoneBins*rlu(2),zoneBins*rlu(3),old_range{4}};


bg_file = 'Bz4D_800meV_bg.mat';
if ~isfile(bg_file)
    sqw800meV_Bz_bg = sqw_op_bin_pixels(src800, @build_bz_background, {r_cut2,rlu},cut_range{:},'-nopix');
    sqw800meV_Bz_bg.filename = 'Bz4D_800meV_bg';
    save(bg_file,'Bz4D_800meV_bg');
else
    load(bg_file);
end


w1bz800_dEbg = cut(sqw800meV_Bz_bg,line_proj,[0.05],[0,1],[0,1],[]);
plot(w1bz800_dEbg);
keep_figure;
%{
w2bz800_100bg = cut(sqw800meV_Bz_bg,[],[],rlu(1)*[-0.1,0.1],[100-5,100+5]);
plot(w2bz800_100bg);
lx 0 4.41;ly 0 4.41;lz 0 1;
grid on
keep_figure;

w2bz1400_100bgs = smooth(w2bz800_100bg,4,'hat');
plot(w2bz1400_100bgs);
lx 0 4.41;ly 0 4.41;lz 0 1;
grid on
keep_figure;

w2bz800_0bg = cut(sqw800meV_Bz_bg,[],[],rlu(1)*[-0.1,0.1],[300-5,300+5]);
plot(w2bz800_0bg);
lx 0 4.41;ly 0 4.41;lz 0 1;
grid on
keep_figure;


%}
if isfile(target)
    sqw800_no_bg = sqw(target);
else    
    avBg = smooth(sqw800meV_Bz_bg,4,'hat');
    x1 = axis_centerpoints(avBg ,1);
    x2 = axis_centerpoints(avBg ,2);
    x3 = axis_centerpoints(avBg ,3);
    x4 = axis_centerpoints(avBg ,4);
    F = griddedInterpolant({x1,x2,x3,x4},avBg.s,'linear','none');
    mi = MagneticIons('Fe0');
    fJi = mi.get_fomFactor_fh();
    sqw800_no_bg = sqw_op_bin_pixels(src800,@remove_background_bz0,{F,rlu,r_cut2,fJi},cut_range{:},'outfile',target);    
end


q1_range = [0,0.005,1];
q2_range = [-0.1,0.1];
q3_range = [-0.1,0.1];
dE_range = [-16,8,600];

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
    [all_cuts,all_proj] = gen_spagetty_fcc(sqw800_no_bg,q1_range,q2_range,q3_range,dE_range, ...
        name_base,sqw_dir,false,true);
    fprintf("*** saving resulting cuts to file: %s\n",cuts_file_name);
    save(cuts_file_name,"all_cuts","-v7.3");
end

%x1=w1_8.p{1};
%x1 = 0.5*(x1(1:end-1)+x1(2:end));
%F1 = griddedInterpolant(x1,w1_8.s);
%sqw800_1Dno_bg = sqw_op(src800,@remove_background1D,{w1_8,F1},'outfile',target);


function cpa = axis_centerpoints(ds,n_axis)
xi = ds.p{n_axis};
cpa = 0.5*(xi(1:end-1)+xi(2:end));
end
