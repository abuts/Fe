data_source= fullfile(pwd,'Data','Fe_ei787.sqw');
proj.u = [1,0,0];
proj.v = [0,1,0];
pos = [1,1,0];

mff = MagneticIons('Fe0');
fixer = @(ws)(mff.fix_magnetic_ff(ws));

erange = [0,8,800];

%1)
outfile = fullfile(pwd,'Data','Fe_ei800shift110.sqw');
zonelist = {[1,1,0],[1,-1,0],[-1,1,0],[0,1,1],[0,1,-1],[0,-1,1],...
    [1,0,1],[1,0,-1],[-1,0,1]}; %,...
    %[2,0,0],[-2,0,0],[0,2,0],[0,-2,0],[0,0,2],[0,0,2]};
tansf_list = combine_equivalent_zones(data_source,proj,pos,...
    {[-1,0.04,1],[-1,0.04,1],[-1,0.04,1]},erange,outfile,zonelist,...
    'symmetry_type','shift','correct_fun',fixer);    

%2)
outfile = fullfile(pwd,'Data','Fe_ei800Sym110.sqw');
tansf_list1 = combine_equivalent_zones(data_source,proj,pos,...
    {[-1,0.04,1],[-1,0.04,1],[-1,0.04,1]},erange,outfile,zonelist,...
    'symmetry_type','sigma','correct_fun',fixer);    

%3)
outfile = fullfile(pwd,'Data','Fe_ei800Sym200.sqw');
zonelist = {[2,0,0],[-2,0,0],[0,2,0],[0,-2,0],[0,0,2],[0,0,-2]};
tansf_listA = combine_equivalent_zones(data_source,proj,[2,0,0],...
    {[-1,0.04,1],[-1,0.04,1],[-1,0.04,1]},erange,outfile,zonelist,...
    'symmetry_type','sigma','correct_fun',fixer);    
%4)
outfile = fullfile(pwd,'Data','Fe_ei800shift200.sqw');
zonelist = {[2,0,0],[-2,0,0],[0,2,0],[0,-2,0],[0,0,2],[0,0,-2]};
tansf_listB = combine_equivalent_zones(data_source,proj,[2,0,0],...
    {[-1,0.04,1],[-1,0.04,1],[-1,0.04,1]},erange,outfile,zonelist,...
    'symmetry_type','shift','correct_fun',fixer);    


%5)
outfile = fullfile(pwd,'Data','Fe_ei800allSym.sqw');
zonelist = {[0,0,0],[1,1,0],[1,-1,0],[-1,1,0],[0,1,1],[0,1,-1],[0,-1,1],...
    [1,0,1],[1,0,-1],[-1,0,1],...
    [2,0,0],[-2,0,0],[0,2,0],[0,-2,0],[0,0,2],[0,0,-2]};
tansf_list2 = combine_equivalent_zones(data_source,proj,[0,0,0],...
    {[-1,0.04,1],[-1,0.04,1],[-1,0.04,1]},erange,outfile,zonelist,...
    'symmetry_type','shift','correct_fun',fixer);    
