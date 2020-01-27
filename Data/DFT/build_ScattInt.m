function  Interp_array = build_ScattInt(en,qx,qy,qz,ses)

nIp = numel(en_pts)+1;
Interp_array = cell(nIp,1);
bin_size = 8;
e_ind = floor(en/bin_size)+1;
for i=1:nIp
    in_bin = e_ind == i;
    s_bin = ses(in_bin,i);
    qx_bin = qx(in_bin);
    qy_bin = qy(in_bin);
    qz_bin = qz(in_bin);
    Interp_array{i}= scatteredInterpolant(qx_bin,qy_bin,qz_bin,s_bin,'linear');
end