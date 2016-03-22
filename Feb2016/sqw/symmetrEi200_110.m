data_source= fullfile(pwd,'Data','Fe_ei200.sqw');
proj.u = [1,0,0];
proj.v = [0,1,0];
pos = [1,1,0];

mff = MagneticIons('Fe0');
fixer = @(ws)(mff.fix_magnetic_ff(ws));

erange = [0,2,200];
outfile = fullfile(pwd,'Data','Fe_ei200Sym110.sqw');
zonelist = {[1,1,0],[1,-1,0],[-1,1,0],[0,1,1],[0,1,-1],[0,-1,1],...
    [1,0,1],[1,0,-1],[-1,0,1]}; %,...
    %[2,0,0],[-2,0,0],[0,2,0],[0,-2,0],[0,0,2],[0,0,2]};
tansf_list = combine_equivalent_zones(data_source,proj,pos,...
    {[-1,0.04,1],[-1,0.04,1],[-1,0.04,1]},erange,outfile,zonelist,...
    'symmetry_type','sigma','correct_fun',fixer);    
%    {[-0.1,0.01,0.1],[-0.1,0.01,0.1],[-0.1,0.01,0.1]},erange,outfile,zonelist);    
