data_source= fullfile(pwd,'Data','Fe_ei200.sqw');
proj.u = [1,0,0];
proj.v = [0,1,0];
pos = [1,1,0];
qstep=qe_range(-0.1,0.05,0.1);
erange = [0,2,200];
outfile = fullfile(pwd,'Data','Fe_ei200Sym110.sqw');
zonelist = {[1,1,0],[1,-1,0],[-1,1,0],[0,1,1],[0,1,-1],[0,-1,1],[1,0,1],[1,0,-1],[-1,0,1]};
combine_equivalent_zones(data_source,proj,pos,qstep,erange,outfile,zonelist);