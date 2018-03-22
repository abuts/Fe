%
w2=make_fitting_cut('d:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw',0.05,2,[1,1,0],[0,1,0]);
plot(w2)

x1 = [-0.2875,-0.0875,0,0.1375,0.3375];
y1 = [95,15,0,19,121];
par = fit_parabola(x1,y1);
fit1=I_on_sw(w2,[0,1,0],par,y1(2),y1(1),-1);
pause
fit1.pic_loc=fit1.pic_loc.close_pics();
fit2=I_on_sw(w2,[0,1,0],par,y1(4),y1(5),1);
pause
fit2.pic_loc=fit2.pic_loc.close_pics();

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



w2=make_fitting_cut('d:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw',0.05,2,[1,1,0],[1,0,0]);
plot(w2);

x2 = [-0.2625,-0.1125,0,0.1375,0.3625];
y2 = [95,19,0,19,123];
par = fit_parabola(x2,y2);


fit3=I_on_sw(w2,[1,0,0],par,y2(2),y2(1),-1);
pause
fit3.pic_loc=fit3.pic_loc.close_pics();

fit4=I_on_sw(w2,[1,0,0],par,y2(4),y2(5),1);
pause
fit4.pic_loc=fit4.pic_loc.close_pics();

xxs1=[fit3.xx,fit4.xx];
yys1=[fit3.yy,fit4.yy];
par2=fit_parabola(xxs1,yys1);

xxi1=min(xxs1):0.01:max(xxs1);
yyi1=fitpar(xxi1,par2);

plot(xxi1,yyi1,'-k');
hold on
plot(xxs1,yys1,'go');


w2=make_fitting_cut('d:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw',0.05,2,[1,1,0],[0,0,1]);
plot(w2)

x3 = [-0.3125,-0.1125,0,0.1375,0.3125];
y3 = [109,21,0,19,107];
par = fit_parabola(x3,y3);

fit5=I_on_sw(w2,[0,0,1],par,y3(2),y3(1),-1);
pause
fit5.pic_loc=fit5.pic_loc.close_pics();
fit6=I_on_sw(w2,[0,0,1],par,y3(4),y3(5),1);
pause
fit6.pic_loc=fit6.pic_loc.close_pics();

xxs2=[fit5.xx,fit6.xx];
yys2=[fit5.yy,fit6.yy];
par3=fit_parabola(xxs2,yys2);

xxi2=min(xxs2):0.01:max(xxs2);
yyi2=fitpar(xxi2,par3);

plot(xxi2,yyi2,'-g');
hold on
plot(xxs2,yys2,'md');


figure
errorbar(fit1.yy,fit1.I,fit1.dI,'-r')
hold on
errorbar(fit2.yy,fit2.I,fit2.dI,'-r')
errorbar(fit3.yy,fit3.I,fit3.dI,'-g')
errorbar(fit4.yy,fit4.I,fit4.dI,'-g')
errorbar(fit5.yy,fit5.I,fit5.dI,'-b')
errorbar(fit6.yy,fit6.I,fit6.dI,'-b')



