function calc_arr = import_Kun_2Q1()

datasets = {'HP.dat','PG.dat','GH.dat','HN.dat','NG.dat','GP.dat','PN.dat'};

q_ptr={[0,0,0],[1,0,0],[0,1,0],[0,0,1]};


q_cen = zeros(3,numel(datasets));
for i=1:numel(datasets )
    [calc_arr,q_end(:,i)] = read_kun(datasets{i},false);
end



