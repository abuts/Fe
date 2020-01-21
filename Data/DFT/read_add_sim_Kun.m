function [ses,qr,en]=read_add_sim_Kun(filename)
% read Kun's volume simulation data and expand these data into the whole
% {[0,0,0];[1,1,1]} cuble
%
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
%[pxs,pys,pzs,ses] = expand_sim_points(qx,qy,qz,es,'visualize');
[pxs,pys,pzs,ses] = expand_sim_points(qx,qy,qz,es);
qr = [pxs,pys,pzs];
en = 8:8:800;
ses = cellfun(@(cl)expand_sim(cl,en),ses,'UniformOutput',false);
ses = [ses{:}];
ses = ses';
ses = reshape(ses,21,21,21,100);


function sexp = expand_sim(serr,en_range)
if isempty(serr)
    sexp  = NaN(numel(en_range),1);
    return;
end
is = ismember(en_range,serr(:,1));
sexp = zeros(numel(en_range),1);
if sum(is) ~=size(serr,1)
    return
else
    sexp(is) = serr(:,2);
end