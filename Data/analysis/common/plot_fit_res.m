
function [figa,figb]= plot_fit_res(sub_cuts,fit_obj,fit_par,en_range,eval_sw,keep_plots)

colour={'k','k','r','r','g','g'};
sel = logical([0,0, 1,1,0,1,0,0, 0,0]);
nplots = numel(sub_cuts);
gp = genieplot.instance();
for j=1:nplots
    gp.line_widths = 0.5;
    if sub_cuts{j}.dimensions() == 2
        w1 = cut(sub_cuts{j},[],[en_range(1),en_range(3)],'-nopix');
    else
        w1  = sub_cuts{j}.data;
    end
    if ~isempty(fit_par)
        cont = fit_par.p(sel);
        sig =  fit_par.sig(sel);
        title = sprintf("S=%4.2g±%4.2g; J0=%4.2g±%4.2g; gamma=%g±%g", ...
            cont(2),sig(2),cont(3),sig(3),cont(1),sig(1));
    else
        title = '';
    end
    w1.axes.title = title;

    acolor(colour{2*j-1});
    if j == 1
        plot(w1);liny;
    else
        pd(w1);
    end
    acolor(colour{2*j});
    gp.line_widths = 2;
    if sub_cuts{j}.dimensions() == 2
        w1fit = cut(fit_obj{j},[],[en_range(1),en_range(3)]);
    else
        w1fit = fit_obj{j};
    end
    pl(w1fit);
    drawnow;
end
figa = gcf;
if keep_plots
    keep_figure;
end
if eval_sw
    keep_figure;
    for j=1:nplots
        gp.line_widths = 0.5;
        if sub_cuts{j}.dimensions() == 2
            w1 = cut(sub_cuts{j},[],[en_range(1),en_range(3)]);
        else
            w1  = sub_cuts{j};
        end
        acolor(colour{2*j-1});
        if j == 1
            plot(w1);liny;
        else
            pd(w1);
        end
        acolor(colour{2*j});
        gp.line_widths = 2;
        w1fit = sqw_eval(w1,@sqw_iron,{fit_par.p,w1.data.proj});
        pl(w1fit);
        drawnow;
    end
    figb = gcf;
    if keep_plots
        keep_figure;
    end
else
    figb = [];
end

end
