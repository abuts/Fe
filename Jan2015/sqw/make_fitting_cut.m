function w2=make_fitting_cut(data_source,DK,DE,uoffset,direction)


Kr = [-1,0.5*DK,1];

proj.type = 'ppp';

%direction = [1,1,0];


prj1=[-DK,+DK];
prj2=[-DK,+DK];
prj0 = Kr;

%proj=projection(direction);
proj.uoffset = uoffset;
[proj.u,proj.v,proj.w]=make_ortho_set(direction);

w2 = cut_sqw(data_source,proj,prj0,prj1,prj2,DE);
