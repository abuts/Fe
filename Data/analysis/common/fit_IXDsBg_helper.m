function [fit_par,fit_ds] = fit_IXDsBg_helper(source_ds,bg_fit_range,plot_fit,line_color)
% helper in fitting log background over given IX1D dataset
% Q-dE direction if background is defined by two 1D exponential funtions
% in energy transfer direction
%
% Inputs:
%
if ~exist("plot_fit",'var')
    plot_fit = false;
end
if ~exist('line_color','var')
    line_color = 'g';
end
if isempty(bg_fit_range)
    ds1 = source_ds;
else
    in_range = source_ds.x>=bg_fit_range(1) & source_ds.x<=bg_fit_range(2);
    xx = source_ds.x(in_range);
    ss = source_ds.signal(in_range);
    ee = source_ds.error(in_range);    
    ds1 = IX_dataset_1d(xx,ss,ee);
end
ds1 = log(ds1);ds1.signal = real(ds1.signal);

if plot_fit
    acolor k
    plot(ds1);liny;
end
fc = multifit(ds1);
fc = fc.set_fun(@linear_bg1D);
fc = fc.set_pin([ds1.signal(1),0]);
fc = fc.set_free([1,1]);
[fd,fit_par] = fc.fit();


if plot_fit
    acolor('g');
    pl(fd);keep_figure;
else
    return;
end

fit_ds = func_eval(source_ds,@double_exp1D,[exp(fit_par.p(1)),fit_par.p(2),0,0]);
if plot_fit
    acolor k;
    pd(source_ds);
    acolor(line_color);
    pd(fit_ds); keep_figure
end

end