
w2=make_fitting_cut('d:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw',0.05,2,[2,0,0],[0,1,0]);
plot(w2)
x1 = [-0.3375,-0.1875,0,0.1875,0.3375];
y1 = [123,31,0,27,137];
par = fit_parabola(x1,y1);
fit1=I_on_sw(w2,[0,1,0],par,15,141,-1);
pause
fit1.pic_loc=fit1.pic_loc.close_pics();
fit2=I_on_sw(w2,[0,1,0],par,20,143,1);
pause
fit2.pic_loc=fit2.pic_loc.close_pics();

%
figure;
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);

xxs=[fit1.xx,fit2.xx];
yys=[fit1.yy,fit2.yy];
par1=fit_parabola(xxs,yys);

xxi=min(xxs):0.01:max(xxs);
yyi1=fitpar(xxi,par1);

plot(xxi,yyi1,'-b');
hold on
plot(xxs,yys,'rs');

w2=make_fitting_cut('d:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw',0.05,2,[2,0,0],[1,0,0]);
plot(w2);

x2 = [-0.3125,-0.0875,0,0.1875,0.3875];
y2 = [139,15,0,19,155];
par = fit_parabola(x2,y2);

fit3=I_on_sw(w2,[1,0,0],par,y2(2),y2(1),-1);
pause
fit3.pic_loc=fit3.pic_loc.close_pics();

fit4=I_on_sw(w2,[1,0,0],par,y2(4),y2(5),1);
pause
fit4.pic_loc=fit4.pic_loc.close_pics();

%
figure;
xxs2=[fit3.xx,fit4.xx];
yys2=[fit3.yy,fit4.yy];
correct=arrayfun(@(x)(abs(x)<0.4),xxs2);
xxs2=xxs2(correct);
yys2=yys2(correct);
par2=fit_parabola(xxs2,yys2);


xxi2=min(xxs2):0.01:max(xxs2);
yyi2=fitpar(xxi2,par2);

plot(xxi2,yyi2,'-k');
hold on
plot(xxs2,yys2,'go');


figure
errorbar(fit1.yy,fit1.I,fit1.dI,'-r')
hold on
errorbar(fit2.yy,fit2.I,fit2.dI,'-r')
errorbar(fit3.yy,fit3.I,fit3.dI,'-g')
errorbar(fit4.yy,fit4.I,fit4.dI,'-g')




