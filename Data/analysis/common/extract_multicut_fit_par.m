function [varargout] = extract_multicut_fit_par(all_fit_par,cut_en,idx)
%[S_eff,J0_eff,G_eff] = extract_fit_par(all_fit_par,idx)
%Extract global fit parameters from fit data to plot
%
if ~exist('idx','var')
    idx = [4,6,3,7]; % S,J0,gamma,J1;
    captions = {...
        'Scattering amplitude';...
        'J0';...
        'DSHO broadening';...
        'J1'...
        };
    units = {...
        'mbarn/(Sr*fmu*meV)';...
        'meV';...
        'meV';...
        'meV'...
        };
else
    ii = 1:numel(idx);
    captions = arrayfun(@(x)(''),ii,UniformOutput=false);
    units = arrayfun(@(x)(''),ii,UniformOutput=false);
end
n_elem  = numel(all_fit_par.p);
cut_en  = cut_en(1:n_elem);

sig = cell(1,numel(idx));
err = cell(1,numel(idx));
for j=1:numel(idx)
    sig{j} = zeros(1,n_elem);
    err{j} = zeros(1,n_elem);
end

for i=1:n_elem
    lsig = all_fit_par.p{i};
    lerr = all_fit_par.sig{i};    

    for j=1:numel(idx)
        sig{j}(i) = abs(lsig(idx(j)));
        err{j}(i) = abs(lerr(idx(j)));
    end
end

ax_x = IX_axis('Energy Transfer (meV)');
for i=1:nargout
    ax_s = IX_axis(captions{i},units{i});
    res = IX_dataset_1d(cut_en,sig{i},err{i});
    res.x_axis = ax_x;
    res.s_axis = ax_s;

    varargout{i} = res;
end
end