function [ses,qx_pts,en_pts,pxs,pys,pzs,ens]=read_add_sim_Kun(combine_with_1D)
% read Kun's volume simulation data and expand these data into the whole
% {[0,0,0];[1,1,1]} cuble
% Outputs:
% ses -- 4D array of calculated/extrapolated signals
% qr  -- 3xnPoints combined array of qx,qy,qz points, corresponding to the
%        q-axis of the simulated arra.
% en  -- energy axis of the simulated array.
%
[qx,qy,qz,En,Sig] = read_add_sim();

[qx,qy,qz,es] = compact3D(En,qx,qy,qz,Sig);
if ~exist('combine_with_1D','var')
    combine_with_1D = false;
end

%
%[pxs,pys,pzs,ses] = expand_sim_points(qx,qy,qz,es,combine_with_1D,'visualize');
[pxs,pys,pzs,ses] = expand_sim_points(qx,qy,qz,es,combine_with_1D);
%
qx_pts = sort(unique(round(pxs,11)));
en_pts = 8:8:800;
ses = cellfun(@(cl)expand_sim(cl,en_pts),ses,'UniformOutput',false);
ens = repmat(en_pts',numel(ses),1);

expanded = cellfun(@(cl)(~isempty(cl)),ses,'UniformOutput',true);

ses = [ses{expanded}];
ses = ses';
%
Nx = numel(qx_pts);
if Nx*Nx*Nx == size(ses,1)
    ses = reshape(ses,Nx,Nx,Nx ,numel(en_pts));
else
    pxs = pxs(expanded);
    pys = pys(expanded);
    pzs = pzs(expanded);
    ens = ens(expanded);
end



function sexp = expand_sim(serr,en_range)
if isempty(serr)
    sexp  = {};
    return;
end
is = ismember(en_range,serr(:,1));
sexp = zeros(numel(en_range),1);
if sum(is) ~=size(serr,1)
    return
else
    sexp(is) = serr(:,2);
end