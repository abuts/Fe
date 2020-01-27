function [pxe,pye,pze,sex] = expand_points(pxe,pye,pze,sex,retained,px,py,pz,se)
% combine array of existing simulation points with additional simulation
% points.
%
% The arrays are in special format, used by read_add_sim_Kun function.
%
pxe = [px;pxe];
pye = [py;pye];
pze = [pz;pze];
if numel(se) == numel(px)
    sexp = se(retained);
    sex = [sex;sexp];
else
    sex  = [];
end

