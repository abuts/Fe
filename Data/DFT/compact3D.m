function [qx,qy,qz,es] = compact3D(En,qx_all,qy_all,qz_all,Sig)
% function used to compacting duplicated q-coordinates values 
% and presenting the sumulation data in the form
% [qx,qy,qz]->{[dE,Signal]} where [q] are the unique points in q-space and
% [dE,Signal] are the array of energy transfers, corresponding to this
% q-point

dE = En(2:end)-En(1:end-1);
eb_block_rngs = [0;find(dE<0);numel(dE)];
% e-ranges
e_rngs = [eb_block_rngs(1:end-1),eb_block_rngs(2:end)];

qx = qx_all(e_rngs(:,2));
qy = qy_all(e_rngs(:,2));
qz = qz_all(e_rngs(:,2));
%qr = [qx,qy,qz];
es = arrayfun(@(rg1,rg2)([En(rg1+1:rg2),Sig(rg1+1:rg2)]),e_rngs(:,1),e_rngs(:,2),...
    'UniformOutput',false);

