function plot_fp(title,rg,varargin)
% Helper function to plot S,J,Gamma dataset arrays for different
% incident energies
colors = {'g','b','r','k'};
if isa(rg,'IX_dataset_1d')
    ranges = {[0.2,2],[10,70],[0,200]};
    argi = [{rg},varargin(:)'];
else
    argi = varargin;
    ranges = [];
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
        pd(ds(i));
        if ~isempty(range)
            ly(range(1),range(2));
        end
    end
    keep_figure;
    if numel(ds) == 3
        lg = {'Ei200','Ei400','Ei800'};        
    else
        lg = {'Ei200','Ei400','Ei800min','Ei800max'};
    end
    legend(lg(1:numel(ds)));
end
end
