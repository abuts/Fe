data_source= fullfile(pwd,'Data','Fe_ei200.sqw');
proj.u = [1,0,0];
proj.v = [0,1,0];
pos = [2,0,0];
qstep=qe_range(-2,0.05,2);
erange = [0,2,200];
outfile = fullfile(pwd,'Data','Fe_ei200Sym200.sqw');
zonelist = {[2,0,0],[-2,0,0],[0,2,0],[0,-2,0],[0,0,2],[0,0,-2]};
combine_equivalent_zones(data_source,proj,pos,qstep,erange,outfile,zonelist);