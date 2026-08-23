function bg_data = extract_bg_par(peak_fit_par,idx)
%[S_eff,J0_eff,G_eff] = extract_bg_par(peak_fit_par,idx)
%Extract background parameters obtained while fitting DSHO oscillator peaks +
%background to experimental results.
%
if ~exist('idx','var')
    idx = [1,2]; %
    captions = {...
        'Background amplitude';...
        'Background slope';...        
        };
    units = {...
        'mbarn/(Sr*fmu*meV)';...        
        'mbarn/(Sr*fmu*meV^2)';...
        };
else
    ii = 1:numel(idx);
    captions = arrayfun(@(x)(''),ii,UniformOutput=false);
    units = arrayfun(@(x)(''),ii,UniformOutput=false);
end
n_idx = numel(idx);
if isfield(peak_fit_par,'valid_chunks')
    n_samples = numel(peak_fit_par(1).valid_chunks);
else
    if iscell(peak_fit_par(1).bp)
        n_samples = numel(peak_fit_par(1).bp);
    else
        n_samples = 1;
    end
end
n_bg_par = n_idx*n_samples;
n_points = numel(peak_fit_par);

bp_plot = nan(n_bg_par,n_points);
bp_sig  = nan(n_bg_par,n_points );
en_axis = zeros(1,n_points);
is_valid  = true(1,n_idx);

try
for i=1:n_points 
    bpl = peak_fit_par(i).bp;
    bgs = peak_fit_par(i).bsig;
    if isfield(peak_fit_par(i),'valid_chunks')
        is_valid = peak_fit_par(i).valid_chunks;
    end
    en_axis(i) = peak_fit_par(i).en;
    nv = 0;
    for j=1:numel(is_valid)
        if ~is_valid(j)
            continue;
        end
        nv = nv +1;
        for k=1:n_idx
            if iscell(bpl)
                bp_plot((j-1)*numel(idx)+k,i) = bpl{nv}(idx(k));
                bp_sig((j-1)*numel(idx)+k ,i) = bgs{nv}(idx(k));
            else
                bp_plot((j-1)*numel(idx)+k,i)  = bpl(idx(k));
                bp_sig((j-1)*numel(idx)+k,i)   = bgs(idx(k));
            end
        end
    end
end
catch Er
    disp(Er.message);
end
bg_data = repmat(IX_dataset_1d(),1,n_bg_par);
ax_x = IX_axis('Energy Transfer (meV)');

for j=1:n_bg_par
    subidx = rem(j-1,numel(idx))+1;
    ax_s = IX_axis(captions{subidx},units{subidx});
    bg_data(j) = IX_dataset_1d(en_axis,bp_plot(j,:),bp_sig(j,:));
    bg_data(j).x_axis = ax_x;
    bg_data(j).s_axis = ax_s;    
    bg_data(j).title = sprintf('%s N %d',captions{subidx},j);
end

end