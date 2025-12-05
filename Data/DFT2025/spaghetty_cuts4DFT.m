function all_cuts = spaghetty_cuts4DFT(sqw_obj,plot_final)

if nargin<2
    plot_final = false; % Default value for plot_final if not provided
end
%
all_proj = containers.Map('KeyType','char','ValueType','any');
%--------------------------------
% GH
all_proj('GH') = {line_proj([1,0,0],[ 0,1,0],'type','rrr'),[0,0.02,1]};
%HN
all_proj('HN') = {line_proj([ 1,-1, 0],[-1,-1,0],'offset',[0,1,0],'type','rrr'),...
    [0,0.01,0.5]};
% GN
all_proj('NG') = {line_proj([1,1,0],[-1,1,0],'type','rrr'),...
    [0.5,0.01,1]};

%GP
all_proj('GP') = {line_proj([1,1,1],[-1,1,1],'type','rrr'),[0,0.01,0.5]};
% PN
all_proj('PN') = {line_proj([0,1,0],[-1,0,1],'offset',[1/2,0,1/2],'type','rrr'),...
    [0.5,0.02,1]};

all_cuts = containers.Map('KeyType','char','ValueType','any');
direction = all_proj.keys;

for i=1:numel(direction)
    %
    fprintf("************************************************************\n");
    dirctn = direction{i};
    fprintf("******* DIRECTION %s\n",dirctn);
    proj_into = all_proj(dirctn);
    all_cuts(dirctn) = cut(sqw_obj,proj_into{1},proj_into{2},[-0.1,0.1],[-0.1,0.1],5,'-nopix');

    fprintf("************************************************************\n");
end

if plot_final
    intensity = [0,2];    
    fc_final=fig_spread('-tight');
    for i=1:numel(direction)
        out_obj = all_cuts(direction{i});
        fh = plot(out_obj);  lz(intensity(1),intensity(2)); keep_figure; 
        fc_final= fc_final.place_fig(fh);
    end
end
