% list of pannels to draw
pannels = {'sGH_Ei800_allSym_bg_rem_ff_corr.fig',...
    'sHN_Ei800_cut_sym_bg_rem_ff_corr.fig',...
    'sNG_ei800_sel_sym_fix_ff_bg_removed.fig',...
    'sGP_Ei800_allSym_bg_rem_ff_corr.fig',...
    'sPN_Ei800_allSym_bg_rem_ff_corr.fig' };
n_pannels = numel(pannels);
s_names = {'GH','HN','NG','GP','PN'};


if ~exist('dnd_figEi800_data','var')
    % if images are loaded, no figure should exist
    dnd_figEi800_data = repmat(d2d(),1,n_pannels);
    for i=1:n_pannels
        openfig(pannels{i});
        drawnow
    end
    for i=1:n_pannels
        fig_data = src(i);
        if isa(fig_data,'sqw')
            dnd_figEi800_data(i) = fig_data.data;
        else
            dnd_figEi800_data(i) = fig_data;            
        end
    end

end
labels = {'G','H','N','G','P','N'};
pl = spaghetti_plot(dnd_figEi800_data,'labels',labels);
lz 0 1;