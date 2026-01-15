function [all_cuts,all_proj,fc_final] = gen_spagetti_bcc(in_sqw,q1_range,q2_range,q3_range,dE_range,name_base,sqw_dir,plot_intermediate,plot_final)
% build spaghetti cuts for fcc lattice and given sqw object
%
if nargin<8
    plot_intermediate = false;
    plot_final        = true;
elseif nargin<9
    plot_final        = plot_intermediate;
end
intensity = [0,5]; % the intensity level set up by this plots signal

all_proj = containers.Map('KeyType','char','ValueType','any');
%--------------------------------
% GN
all_proj('GN') = [...
    line_proj([1,1,0],[-1,1,0],'type','rrr'),...
    line_proj([1,0,1],[ 0,1,0],'type','rrr'),...
    line_proj([0,1,1],[ 1,0,0],'type','rrr')];
%HN
all_proj('NH') = [...
    line_proj([ 1,-1, 0],[-1,-1,0],'offset',[0,1,0],'type','rrr'),...
    line_proj([-1, 0, 1],[ 1, 0,1],'offset',[1,0,0],'type','rrr'),...
    line_proj([ 0, 1,-1],[ 0, 1,1],'offset',[0,0,1],'type','rrr')];
% GH
all_proj('GH') = [...
    line_proj([1,0,0],[ 0,1,0],'type','rrr'),...
    line_proj([0,1,0],[ 0,0,1],'type','rrr'),...
    line_proj([0,0,1],[-1,0,0],'type','rrr')];
%GP
all_proj('GP') = line_proj([1,1,1],[-1,1,1],'type','rrr');
% PN
all_proj('PN') = [...
    line_proj([0,1,0],[-1,0,1],'offset',[1/2,0,1/2],'type','rrr'),...
    line_proj([1,0,0],[0,-1,1],'offset',[0,1/2,1/2],'type','rrr'),...
    line_proj([0,0,1],[-1,1,0],'offset',[1/2,1/2,0],'type','rrr')]; % [0,0,1] direction gives strange streaks (spin liquid :-) ?)



all_cuts = containers.Map('KeyType','char','ValueType','any');
direction = all_proj.keys;
for i=1:numel(direction)
    %
    fprintf("************************************************************\n");
    fprintf("******* DIRECTION %s\n",direction{i});
    all_cuts(direction{i}) = ...
        combine_mpulticut(in_sqw,all_proj(direction{i}), ...
        q1_range,q2_range,q3_range,dE_range,intensity,sqw_dir, ...
        sprintf("%s_%s_comb",name_base,direction{i}),plot_intermediate);
    fprintf("************************************************************\n");
end

if plot_final
    fc_final=fig_spread('-tight');
    for i=1:numel(direction)
        out_obj = all_cuts(direction{i});
        fh = plot(out_obj);  lz(intensity(1),intensity(2)); keep_figure; 
        fc_final= fc_final.place_fig(fh);
    end
end
end

function out_obj = combine_mpulticut(sqw_obj,proj_array,dq1,dq2,dq3,dE,intensity,sqw_dir,file_tag,plot_intermediate)
%
alatt = sqw_obj.data.alatt;
angdeg= sqw_obj.data.angdeg;


if plot_intermediate
    fs=fig_spread('-tight');
end
n_cuts2comb = numel(proj_array);
cuts_list= cell(1,n_cuts2comb);
for i = 1:n_cuts2comb
    proj = proj_array(i);
    proj.alatt  = alatt;
    proj.angdeg = angdeg;
    proj_array(i) = proj;
    cuts_list{i} = cut(sqw_obj,proj,dq1,dq2,dq3,dE);
    if plot_intermediate
        fh = plot(cuts_list{i}); lz(intensity(1),intensity(2)); keep_figure;
        fs = fs.place_fig(fh);
    end
end
%
out_obj = sqw_op_bin_pixels(cuts_list,@move_all_to_proj,{proj_array,dq2},...
    proj_array(1),dq1,dq2,dq3,dE, ...
    '-combine',...
    'outfile',fullfile(sqw_dir,file_tag));
if plot_intermediate
    fh = plot(out_obj);  lz(intensity(1),intensity(2)); keep_figure; fs.place_fig(fh);
end
%
end