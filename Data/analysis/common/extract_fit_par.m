function [varargout] = extract_fit_par(all_fit_par,idx)
%[S_eff,J0_eff,G_eff] = extract_fit_par(all_fit_par,idx)
%Extract global fit parameters from fit data to plot
%
if ~exist('idx','var')
    idx = [4,3,6]; % gamma,S and J0;
    captions = {...
        'Scattering amplitude';...
        'DSHO broadening';...
        'J0'...
        };
    units = {...
        'mbarn/(Sr*fmu*meV)';...
        'meV';...
        'meV'...
        };
else
    ii = 1:numel(idx);
    captions = arrayfun(@(x)(''),ii,UniformOutput=false);
    units = arrayfun(@(x)(''),ii,UniformOutput=false);
end
n_elem  = numel(all_fit_par);
cut_en  = zeros(1,n_elem);

sig = cell(1,numel(idx));
err = cell(1,numel(idx));
for j=1:numel(idx)
    sig{j} = zeros(1,n_elem);
    err{j} = zeros(1,n_elem);
end


for i=1:n_elem

    if iscell(all_fit_par)
        fit_par = all_fit_par{i};
    else
        fit_par = all_fit_par(i);
    end
    cut_en(i) = fit_par.en;
    for j=1:numel(idx)
        sig{j}(i) = abs(fit_par.p(idx(j)));
        err{j}(i) = abs(fit_par.sig(idx(j)));
    end
end


[en_bins,ord_idx] = sort(cut_en);
for j=1:numel(idx)
    sig{j} = sig{j}(ord_idx);
    err{j} = err{j}(ord_idx);
end


ax_x = IX_axis('Energy Transfer (meV)');
for i=1:nargout
    ax_s = IX_axis(captions{i},units{i});
    res = IX_dataset_1d(en_bins,sig{i},err{i});
    res.x_axis = ax_x;
    res.s_axis = ax_s;
    varargout{i} = res;
end
end