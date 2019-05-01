function [calc_arr,dir] = import_Kun_2Q1()
%              1        2       3         4       5        6       7
datasets = {'HP.dat','PG.dat','GH.dat','HN.dat','NG.dat','GP.dat','PN.dat'};


q_dir = zeros(6,numel(datasets));
imp_arr = cell(1,numel(datasets));
for i=1:numel(datasets )
    [imp_arr{i},q_dir(:,i)] = read_kun(datasets{i},false);
end

%keys = {'GH','GN2','GP_PH','HN2'};
val  = {@()calc_GH(imp_arr,q_dir,3),@()calc_GN2(imp_arr,q_dir,5),...
    @()calc_HPPG(imp_arr,q_dir,[1,2]),@()calc_HN2(imp_arr,q_dir,4),...
    @()calc_PN2(imp_arr,q_dir,7)};
calc_arr = cell(numel(val),1);
dir      = cell(numel(val),1);
for i=1:numel(val)
    fh = val{i};
    [calc_arr{i},dir{i}] =fh();
end



function [gh,dir]= calc_GH(inp_arr,q_dir,ds_num)
gh = inp_arr{ds_num};

dir = reshape(q_dir(:,ds_num),3,2)';

function [gn2,dir]= calc_GN2(inp_arr,q_dir,ds_num)
gn = inp_arr{ds_num};
%dir = reshape(q_dir(:,ds_num),3,2)';

s = gn{3};
S1= [fliplr(s),s(:,2:end)];
q_end = sqrt(2); 
q = linspace(0,q_end,size(S1,2));
dE = gn{2}(:,1);
[qs,es] = ndgrid(q,dE);
gn2 = {qs',es',S1};
dir = [0,0,0;1,1,0];


function [sig,dir]= calc_HPPG(inp_arr,q_dir,ds_num)
hp = inp_arr{ds_num(1)};
pg = inp_arr{ds_num(2)};

dir1 = reshape(q_dir(:,ds_num(1)),3,2)';
dir2 = reshape(q_dir(:,ds_num(2)),3,2)';
s2 = pg{3};
S1 = fliplr([hp{3},s2(:,2:end)]);
q_end = sqrt(3); 
q = linspace(0,q_end,size(S1,2));
dE = hp{2}(:,1);
[qs,es] = ndgrid(q,dE);
sig = {qs',es',S1};
dir = [0,0,0;1,1,1];


function [sig,dir]= calc_HN2(inp_arr,q_dir,ds_num)
hn = inp_arr{ds_num};
dir = reshape(q_dir(:,ds_num),3,2)';
s1 = hn{3};
S1 = [s1(:,1:end-1),fliplr(s1)];
q_end = sqrt(2); 
q = linspace(0,q_end,size(S1,2));
dE = hn{2}(:,1);
[qs,es] = ndgrid(q,dE);
sig = {qs',es',S1};
dir = [1,0,0;0,1,0];


function [sig,dir]= calc_PN2(inp_arr,q_dir,ds_num)
pn = inp_arr{ds_num};
dir = reshape(q_dir(:,ds_num),3,2)';
s1 = pn{3};
S1 = [fliplr(s1),s1(:,2:end),];
q_end = 1; 
q = linspace(0,q_end,size(S1,2));
dE = pn{2}(:,1);
[qs,es] = ndgrid(q,dE);
sig = {qs',es',S1};
dir = [1/2,1/2,0;1/2,1/2,1];

