function plot_unchanged_fcc(sqw_in,all_proj,q1_range,q2_range,q3_range,dE_range)
%PLOT_UNCHANGED_FCC Plot set of cuts defined by input projections list
%

fs = fig_spread();
dir = all_proj.keys;
for i=1:numel(dir)
    dir_proj = all_proj(dir{i});
    w2Bg = cut(sqw_in,dir_proj(1),q1_range,q2_range,q3_range,dE_range,'-nopix');
    fh = plot(w2Bg ); lz 0 0.5; keep_figure;fs.place_fig(fh);
end
