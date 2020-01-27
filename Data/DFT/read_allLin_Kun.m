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
    qx = qx(1,:)';
    qy = qy(1,:)';
    qz = qz(1,:)';
    ss = arrayfun(@(i)([dE(:,i),Sig(:,i)]),1:size(dE,2),...
        'UniformOutput',false);
    ss = ss';
    
    retained = true(size(qx));
    [px,py,pz,Es] = expand_points(px,py,pz,Es,retained,qx,qy,qz,ss);
end
