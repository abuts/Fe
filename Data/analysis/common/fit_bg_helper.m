function cuts2fit = fit_bg_helper(cuts2fit,source_ds,cut1_proj,cut2_proj,bg_Qrange,bg_en_range,init_bg_par,field_name,other_range,plot_fit)
% helper in fitting background parameters in specific Q-range for specific
% Q-dE direction if background is defined by two 1D exponential funtions
% in energy transfer direction
%
% Inputs:
% cuts2fit  -- structure containing results of all fits.
% source_ds -- sqw object to identify background function
% cut1_proj -- projection which defines first background direction
% cut2_proj -- projection which defines second background direction. Both
%              directions are bound by symmetry so the backgrounds should
%              be very similar to be fit with single background function
% bg_Qrange -- integration range for background over momenum in background
%              measuring direction. [Q_min,Q_max]
% bg_enRange-- range of background axis to fit [dE_min,step,dE_max]
% init_bg_par- 3 initial values for background parameters. Forth initial
%              value is the signal at dE_min
%field_name -- name of the cuts2fit structure, to store resulting
%              background parameters in
%other_range --background is build on the basis of 2-D cut while source-ds is 4D
%              dataset. other_range defines ranges used to take 2-D Q-dE
%              cut from whole 4-D dataset.
%
if ~exist('plot_fit','var')
    plot_fit = true;
end
if iscell(bg_Qrange)
    ds1 = IX_dataset_1d(cut(source_ds,cut1_proj,bg_Qrange{1},other_range{1:2},bg_en_range,'-nopix'));
    ds2 = IX_dataset_1d(cut(source_ds,cut2_proj,bg_Qrange{2},other_range{1:2},bg_en_range,'-nopix'));
else
    ds1 = IX_dataset_1d(cut(source_ds,cut1_proj,bg_Qrange,other_range{1:2},bg_en_range,'-nopix'));
    ds2 = IX_dataset_1d(cut(source_ds,cut2_proj,bg_Qrange,other_range{1:2},bg_en_range,'-nopix'));
end
ds1 = log(ds1);ds1.signal = real(ds1.signal);
ds2 = log(ds2);ds2.signal = real(ds2.signal);
if plot_fit
    acolor k
    plot(ds1);liny;
    pd(ds2);
end
fc = multifit(ds1,ds2);
fc = fc.set_fun(@double_exp1Dlog);
fc = fc.set_pin([ds1.signal(1),init_bg_par(:)']);
fc = fc.set_free([1,1,1,1]);
[fd,fp] = fc.fit();

%fp.p(3) = abs(fp.p(3));
cuts2fit.(field_name) = fp;

if plot_fit
    acolor g
    pl(fd{1});
    acolor b
    pl(fd{2});keep_figure;
else
    return;
end

if iscell(bg_Qrange)
    w1t= cut(source_ds,cut1_proj,bg_Qrange{1},other_range{:},'-nopix');
    acolor k;plot(w1t);logy;
    tf = func_eval(w1t,@double_exp1D,fp.p);
    acolor r
    pd(tf);
    w1t= cut(source_ds,cut2_proj,bg_Qrange{2},other_range{:},'-nopix');
    acolor k;pl(w1t);
    tf = func_eval(w1t,@double_exp1D,fp.p);
    acolor r
    pd(tf); keep_figure
else
    w1t= cut(source_ds,cut1_proj,bg_Qrange,other_range{:},'-nopix');
    plot(w1t);logy;
    tf = func_eval(w1t,@double_exp1D,fp.p);
    acolor r
    pd(tf); keep_figure
end
end