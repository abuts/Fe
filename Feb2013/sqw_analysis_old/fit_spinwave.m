function p=fit_spinwave(w2)


%parab = @(x,y,p) (p(1).*exp(-p(2)*abs(y-p(3)*x.^2.*(1-p(4)*x.^2))));
parab = @(x,y,p) (p(1).*exp(-p(2)*abs(y-p(3)*x.^2)));
% % parameters for [2,y,0], Ei=200mEv;
p0 = [0.1,0.02,372/0.45];
% parameters for [2+x,y,0], Ei=200mEv;
%p0 = [0.1,0.02,153/0.425];


[ff,t]=fit(w2,parab,p0);

plot(ff)
keep_figure;
plot(w2)
p = t.p;

qrange = [w2.data.urange(:,2),w2.data.urange(:,4)];


x=linspace(qrange(1,1),qrange(2,1));
y=linspace(qrange(1,2),qrange(2,2));
 
[xx,yy]=meshgrid(x,y);
zz=parab(xx,yy,p);

hold on
%[C,h]=contour(xx,yy,zz);
contour(xx,yy,zz);


