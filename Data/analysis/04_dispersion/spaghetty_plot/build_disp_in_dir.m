function [w2,fh] = build_disp_in_dir(cuts_map)
%

keys  = cuts_map.keys();
zones = containers.Map('KeyType','double','ValueType','any');

ff = findobj('type', 'figure', 'Number', 1);
if isempty(ff)
    load_figures = true;
else
    load_figures = false;
end

sources = cell(1,numel(keys));
src_proj = repmat(line_proj,1,numel(keys));
for i=1:numel(keys)
    data = cuts_map(keys{i});
    if iscell(data )
        range = data{1};
        offset = data{2};
    else
        range = data;
        offset = NaN;
    end
    if load_figures
        openfig(keys{i});
        fh = gcf;
        sources{i} = src(fh);
    else
        sources{i} = src(i);
    end
    zones(i) = range;
    src_proj(i) = sources{i}.data.proj;
    if ~isnan(offset)
        src_proj(i).offset= offset;
    end
end


lp = sources{1}.data.proj;
scales = sources{1}.data.axes.img_scales;
targ_proj = lp;
targ_proj.type = 'aaa';
targ_proj.offset = [0,0,0];
lp.offset = [0,0,0];
w2 = sqw_op_bin_pixels(sources,@combine_en_zones,{zones,lp,src_proj}, ...
    targ_proj,[0,0.02,1]*scales(1),[-0.1,0.1]*scales(2),[-0.1,0.1]*scales(3),[0,5,400], ...
    '-combine');
%targ_proj,[0,0.005,0.5],[-0.1,0.1],[-0.1,0.1],[0,5,400], ...

x = repmat(w2.data.img_range(:,1),1,numel(keys));
mr =cellfun(@(x)cuts_map(x),keys,'UniformOutput',false);
if isnan(offset)
    y1 = cellfun(@(x)x(2),mr);    
else
    y1 = cellfun(@(x)x{1}(2),mr);    
end
y = [y1;y1];
[fh,ah] = plot(w2); lz 0 2;
line(ah,x,y,'Color','red','LineStyle','--');
end
