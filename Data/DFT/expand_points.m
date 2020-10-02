function [pxe,pye,pze,seex] = expand_points(pxe,pye,pze,seex,retained,px,py,pz,se)
% combine array of existing simulation points with additional simulation
% points.
% pxe,pye,pze 3 1D arrays defining q-point
% seex          1D cellarray containgin signal-scattering intensity for the 
%               q-points, returned as output.
% px,py,pz      q-points to append
% se -- signal-scattering intensity array to append to the initial array
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

