function [px,py,pz,Es] = read_allLin_Kun()
%labels   = {'H','P',' \Gamma','H','N',' \Gamma','P','N'};
datasets = {'HP.dat','PG.dat','GH.dat','HN.dat','NG.dat','GP.dat','PN.dat'};

%calc_arr = repmat(IX_dataset_2d(),numel(datasets),1);
px = [];
py = [];
pz = [];
Es = {};
for i=1:numel(datasets)
    [~,~,qx,qy,qz,dE,Sig] = read_kun(datasets{i},false,false);
    [qx,qy,qz,ss] = compact3D(reshape(dE,numel(dE),1),...
        reshape(qx,numel(qx),1),...
        reshape(qy,numel(qy),1),...
        reshape(qz,numel(qz),1),...        
        reshape(Sig,numel(Sig),1));
    %all_size = cellfun(@(x)size(x,1),ss,'UniformOutput',true);
    retained = true(size(qx));
    [px,py,pz,Es] = expand_points(px,py,pz,Es,retained,qx,qy,qz,ss);
end
