% list of pannels to draw
pannels = {'GH_100_allEn_allSym_bgRem_ffCor.fig',...
    'HN_010_0p50p50_allEn_allSym_bgRem_ffCor.fig',...
    'NG_110_allEn_allSym_bgRem_ffCor.fig',...
    'GP_0p50p50p5_allEn_allSym_bgRem_ffCor.fig',...
    'PN_0p50p50p5_0p50p50_allEn_allSym_bgRem_ffCorT1.fig' };
n_pannels = numel(pannels);
s_names = {'GH','HN','NG','GP','PN'};


if ~exist('dnd_fig_data','var')
    % if images are loaded, no figure should exist
    dnd_fig_data = repmat(d2d(),1,n_pannels);
    for i=1:n_pannels
        openfig(pannels{i});
        drawnow
    end
    for i=1:n_pannels
        dnd_fig_data(i) = src(i);
    end

end
labels = {'G','H','N','G','P','N'};
pl = spaghetti_plot(dnd_fig_data,'labels',labels);
lz 0 1;