function [pxe,pye,pze,seex] = expand_points(pxe,pye,pze,seex,retained,px,py,pz,se)
% combine array of existing simulation points with additional simulation
% points.
%
% The arrays are in special format, used by read_add_sim_Kun function.
%
pxe = [pxe;px];
pye = [pye;py];
pze = [pze;pz];
if numel(se) == numel(retained)
    sexp = se(retained);
    seex = [seex;sexp];
else
    %seex  = [];
end

