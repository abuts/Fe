function varargout=plot_SJG_results(fit_res,base_color,field_names,ranges,comp_data)
% Plot or overplot specific IX_dataset fields of the input structure
% provided
do_comparison = exist("comp_data","var");
data_provided_directly = iscell(fit_res);

ff = fig_spread();
gp = genieplot.instance;
for i=1:numel(field_names)
    if data_provided_directly 
        plot_obj = fit_res{i};
    else
        plot_obj = fit_res.(field_names{i});
    end
    if do_comparison
        acolor('k');gp.marker_types = {'x'};
        fh = pd(comp_data{i});liny;        
        acolor(base_color);gp.marker_types = {'o'};
        pd(plot_obj);keep_figure;
    else
        acolor(base_color);
        fh = pd(plot_obj);liny;keep_figure;
    end
    ff = ff.place_fig(fh);
    ly(ranges{i}(1),ranges{i}(2));
    varargout{i} = plot_obj;
end

end