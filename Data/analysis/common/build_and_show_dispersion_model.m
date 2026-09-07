function build_and_show_dispersion_model(fg,pl_pannels,param)
% find spaghetty plot or build it from input parameters
% and add dispersion model to this spaghetty plot

figure(fg);
hold on;
pl = findobj(fg,'Tag','Fe_Dispersion_model');
if ~isempty(pl)
    if isgraphics(pl)
        delete(pl);
    end
end

ax = fg.CurrentAxes;
ax.Title.String = num2str(param(:)');

pl = sw_plot_from_proj_data(pl_pannels,param);
pl.LineWidth = 2;
pl.Color = 'r';
pl.Tag = 'Fe_Dispersion_model';

end
