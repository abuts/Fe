function plot_fp_var(separate_figures,color,varargin)
% helper function ploting various fitting parameters graphs 
% in live scripts
% separate_figures -- if true, live script plots figures separately
% color            -- symbol describing figures color
% varargin         -- cellarray of arrays of different datasets to plot
%

ranges = {[0.5,2],[10,70],[0,200]};
types = {'o','x','+','d','*'};
gp = genieplot.instance();
gp.marker_types = types;
acolor(color);
for j=1:numel(varargin)
    ds = varargin{j};
    if iscell(ds)
        valid = cellfun(@(x)(~isempty(x)),ds);
        ds = [ds{valid}];

    else
        valid = true(1,numel(ds));
    end
    if separate_figures
        fg = pd(ds);
        set(fg,'Visible','on')
    else
        pd(ds);
    end
    range = ranges{j};

    ly(range(1),range(2))
    keep_figure;
    if numel(varagin)>4
        lg =  {'<110> minFF','<200> minFF','<110> mid FF','<110> max FF','<200> max FF'};        
    else
        lg =  {'<110> minFF','<200> minFF','<110> max FF','<200> max FF'};
    end
    lg = lg(valid);
    legend(lg);
end
end

