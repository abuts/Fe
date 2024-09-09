function  Interp_array = build_ScattInt(en_pts,qx,qy,qz,en,ses)
% build function to use 
%
if all(size(en_pts) == size(qx))
    en_pts = unique(sort(en_pts));
    nIp = numel(en_pts);
else
    nIp = numel(en_pts);
end
if size(ses,2) > 1
    binned = true;
else
    binned = false;
end
Interp_array = cell(nIp,1);
bin_size = 8;

e_ind = floor(en/bin_size);
n_empties = 0;
n_binv = max(e_ind);
for i=1:n_binv
    in_bin = e_ind == i;
    if binned
        s_bin = ses(i,in_bin)';
    else
        s_bin = ses(in_bin);
    end
    if isempty(s_bin)
        n_empties = n_empties+1;
        continue;
    end
    qx_bin = qx(in_bin);
    qy_bin = qy(in_bin);
    qz_bin = qz(in_bin);
    Interp_array{i}= scatteredInterpolant(qx_bin,qy_bin,qz_bin,s_bin,'natural');
end
if isempty(Interp_array{end})
    Interp_array{end} = Interp_array{end-1};
end