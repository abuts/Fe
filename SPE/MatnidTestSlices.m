proj_100.u = [1,0,0];
proj_100.v = [0,1,0];
proj_100.type = 'rrr';
proj_100.uoffset = [0,0,0,0];
data_source = 'fe_E400_fake.sqw';
x_lim=[-1,0.05,5];
y_lim=[-3,0.05,5];

w2EM20 = cut_sqw(data_source,proj_100,x_lim,y_lim,[-0.2,0.2],[-20,-10],'-nopix');
plot(w2EM20);
keep_figure
w2E0 = cut_sqw(data_source,proj_100,x_lim,y_lim,[-0.2,0.2],[-5,5],'-nopix');
plot(w2E0);
keep_figure
w2E10 = cut_sqw(data_source,proj_100,x_lim,y_lim,[-0.2,0.2],[10,20],'-nopix');
plot(w2E10);
keep_figure
w2E30 = cut_sqw(data_source,proj_100,x_lim,y_lim,[-0.2,0.2],[30,40],'-nopix');
plot(w2E30);
keep_figure
w2E70 = cut_sqw(data_source,proj_100,x_lim,y_lim,[-0.2,0.2],[70,80],'-nopix');
plot(w2E70);
keep_figure
%---------------------------------
proj_2.u = [1,0,0];
proj_2.v = [0,0,1];
x_lim=[-1,0.05,5];
z_lim=[-3,0.05,5];
w2yE30 = cut_sqw(data_source,proj_100,x_lim,[-0.2,0.2],z_lim,[30,40],'-nopix');

w2yE0=cut_sqw(data_source,proj_100,[-1,0.05,1],[-1.8,-1.4],0.05,[-5,5],'-nopix');

