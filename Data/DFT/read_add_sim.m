function [qr,ses]=read_add_sim(filename)
% read Kun's volume simulation data and expand these data into the whole
% cuble
fh = fopen(filename,'rt');
if fh<0
    error('READ_ADD_SIM:runtime_error',...
        'Can not open input data file %s',filename);
end
clob = onCleanup(@()fclose(fh));
data = textscan(fh,'%f %f %f %f %f');

En = data{4};
dE = En(2:end)-En(1:end-1);
eb_block_rngs = [0;find(dE<0)];
e_rngs = [eb_block_rngs(1:end-1),eb_block_rngs(2:end)];

qx_all = data{1};
qy_all = data{2};
qz_all = data{3};
Sig = data{5};
qx = qx_all(e_rngs(:,2));
qy = qy_all(e_rngs(:,2));
qz = qz_all(e_rngs(:,2));
%qr = [qx,qy,qz];
es = arrayfun(@(rg1,rg2)([En(rg1+1:rg2),Sig(rg1+1:rg2)]),e_rngs(:,1),e_rngs(:,2),...
    'UniformOutput',false);
[pxs,pys,pzs,ses] = expand_sim_points(qx,qy,qz,es);
qr = [pxs,pys,pzs];