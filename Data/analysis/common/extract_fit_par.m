function [varargout] = extract_fit_par(all_fit_par,idx)
%[S_eff,J0_eff,G_eff] = extract_fit_par(all_fit_par,idx)
%Extract global fit parameters from fit data to plot
%
if ~exist('idx','var')
    idx = [4,6,3,4]; % gamma,S J0,S;
    captions = {...
        'Scattering amplitude';...
        'J0';...
        'DSHO broadening';...
        'Scattering amplitude'...
        };
    units = {...
        'mbarn/(Sr*fmu*meV)';...
        'meV';...
        'meV';...
        'mbarn/(Sr*fmu*meV)'...
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

q = zeros(1,n_elem);
q_dep_defined = false;
for i=1:n_elem

    if iscell(all_fit_par)
        fit_par = all_fit_par{i};
    else
        fit_par = all_fit_par(i);
    end
    cut_en(i) = fit_par.en;
    if isfield(fit_par,'q_max')
        q(i) = fit_par.q_max;
        q_dep_defined = true;
    end
    for j=1:numel(idx)
        sig{j}(i) = abs(fit_par.p(idx(j)));
        err{j}(i) = abs(fit_par.sig(idx(j)));
    end
end
if nargout<4
    q_dep_defined = false;    
end


[en_bins,ord_idx] = sort(cut_en);
for j=1:numel(idx)
    sig{j} = sig{j}(ord_idx);
    err{j} = err{j}(ord_idx);
end
if q_dep_defined
    q = q(ord_idx);
    qu = unique(q);
    n_unique = numel(qu);
    while n_unique ~= numel(q)
        % modify q so all non-unique elements become unique but actual 
        % difference in value of modified elements is negigable.
        % very crude code
        for i=1:numel(qu)
            eq_elements = qu(i) == q;
            if sum(eq_elements)>1
                first_unique = find(eq_elements,1);
                step= 0.0001*(qu(end)-qu(1))/numel(qu);
                n_elem = numel(q)-first_unique+1;
                add = step*(0:n_elem-1);
                q(first_unique:n_elem) = q(first_unique:n_elem)+add;
                [q,idx] = sort(q);
                sig{4} = sig{4}(idx);
                err{4} = err{4}(idx);                
                qu = unique(q);
                n_unique = numel(qu);                
                break
            end
        end
    end
end


ax_x = IX_axis('Energy Transfer (meV)');
if q_dep_defined
    ax_q = IX_axis('q along dir');
end
for i=1:nargout
    ax_s = IX_axis(captions{i},units{i});
    if q_dep_defined  && i==4
        res = IX_dataset_1d(q,sig{i},err{i});
        res.x_axis = ax_q;
        res.s_axis = ax_s;
    else
        res = IX_dataset_1d(en_bins,sig{i},err{i});
        res.x_axis = ax_x;
        res.s_axis = ax_s;
    end

    varargout{i} = res;
end
end