function fin_cut = get_finalGPH()

data = fullfile(fileparts(fileparts(mfilename('fullpath'))),'Data','sqw','Fe_ei787.sqw');
Emax = 500;
dE   = 5;

Dqk = [-0.1,0.1];
Dql = [-0.1,0.1];
u = [-1,1,1];
v = [1,1,0];
proj = projection(u,v,'uoffset',[3,0,0]);
a = [-1,1,1]; b = [-1,-1,1];
rot_xy1 = cross(a,b);
rot_xy1 = rot_xy1/sqrt(rot_xy1*rot_xy1');
alp_xy = acosd(a*b'/(sqrt(a*a')*sqrt(b*b')));

a = [-1,1,1]; b = [-1,1,-1];
rot_xz1 = cross(a,b);
rot_xz1 = rot_xz1/sqrt(rot_xz1*rot_xz1');
alp_xz = acosd(a*b'/(sqrt(a*a')*sqrt(b*b')));

a = [-1,1,1]; b = [-1,-1,-1];
rot_xyz1 = cross(a,b);
rot_xyz1 = rot_xyz1/sqrt(rot_xyz1*rot_xyz1');
alp_xyz1 = acosd(a*b'/(sqrt(a*a')*sqrt(b*b')));


keep_only_last_plot = false;
sym_op = {symop(rot_xy1,alp_xy,[3,0,0]),symop(rot_xz1,alp_xz,[3,0,0]),symop(rot_xyz1,alp_xyz1,[3,0,0]),...
    symop([0,0,1],90),...
    [symop(rot_xy1,alp_xy,[3,0,0]),symop([0,0,1],90)],...
    [symop(rot_xz1,alp_xz,[3,0,0]),symop([0,0,1],90)],...
    [symop(rot_xyz1,alp_xyz1,[3,0,0]),symop([0,0,1],90)]};
%{symop([0,0,1],90),[symop([1,0,0],90),symop([0,0,1],90)]};
sym_axis = {[1,0,0];[0,-1,0]; [2.5,-0.5,0]};

fin_cut = cut_symop(data,proj,[-1,0.04,2.5],Dqk ,Dql ,[0,dE,Emax],...
[],{[-1,-0.5],[2.,2.5]},...
    sym_op,sym_axis,keep_only_last_plot );
fp = d2d(fin_cut);
fps = smooth(fp);
plot(fps);
lz 0 0.5
keep_figure;
