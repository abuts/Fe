data_source= fullfile(pwd,'Data','Fe_ei401.sqw');
proj.u = [1,0,0];
proj.v = [0,1,0];
pos = [1,1,0];
qstep=qe_range(-0.1,0.04,0.1);
erange = [0,5,395];
outfile = fullfile(pwd,'Data','Fe_ei400Sym110.sqw');
%set(hor_config,'accumulating_process_num',9);
zonelist = {[1,1,0],[1,-1,0],[-1,1,0],[0,1,1],[0,1,-1],[0,-1,1],[1,0,1],[1,0,-1],[-1,0,1]};
combine_equivalent_zones(data_source,proj,pos,qstep,erange,outfile,zonelist);