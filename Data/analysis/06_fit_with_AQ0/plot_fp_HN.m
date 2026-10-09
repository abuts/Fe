function plot_fp_HN(separate_fig,title,rg,varargin)
% Helper function to plot S,J,Gamma dataset arrays for different
% incident energies
if isa(rg,'IX_dataset_1d')
    ranges = {[0.,100],[0,2000],[0,200000],[0,10000]};
    argi = [{rg},varargin(:)'];
else
    argi = varargin;
    ranges = [];
end
ds = argi{1};
colors = {'g','b','r','k','y'};    
if numel(ds) == 2
    lg = {'Ei800f','Ei800t','Ei800'};            
elseif numel(ds) == 3
    lg = {'Ei200','Ei400','Ei800'};        
elseif numel(ds) == 4
    lg = {'Ei200','Ei400','Ei800min','Ei800max'};        
else
    lg = {'Ei200','Ei400','Ei800min','Ei800mid','Ei800max'};        
    colors = {'g','b','r','y','k'};        
end


for j=1:numel(argi )
    ds = argi{j};
    if ~isempty(ranges)
        range = ranges{j};
    else
        range  = [];
    end
    ds(1).title = title;
    for i=1:numel(ds)
        acolor(colors{i});
        if separate_fig
            fg = pd(ds(i));
            set(fg,'Visible','on')
        else
            pd(ds(i));
        end
        if ~isempty(range)
            ly(range(1),range(2));
        end
    end
    keep_figure;
    legend(lg(1:numel(ds)));
end
end
