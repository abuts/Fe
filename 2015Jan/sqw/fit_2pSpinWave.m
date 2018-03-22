function [swPar,qs,es,q_err,IonBr1,IonBr2] = fit_2pSpinWave(datasource,bragg,swPar,c1,c2,no_chkpts,Imax)
%
%
% Returns:
% parR -- coefficients of the parabola approximating the spit wave
%         (p(1)+p(2)*x+p(3)*x^2)
% qs,es -- the q and E points on the spin wave where the cuts were taken
% IonBr1,IonBr2 -- the IXTdataset_1d objects of the intensity along 2 branches of the
%                  wave.

cutDir = swPar.cut_direction;
dk     = swPar.dk;
dE     = swPar.dE;
w2=make_fitting_cut( datasource,dk,dE,bragg,cutDir);
f1=plot(w2);
lz 0 2
hold on
% remember the place of the last image and place the impage to proper
% posision
swPar.result_pic = pic_spread();
swPar.result_pic = swPar.result_pic.place_pic(f1);

swPar.legend = swPar.getTextFromVector(bragg);
[fit1,swPar]=I_on_sw2Peak(w2,cutDir,swPar,dk,dE,-1,[1,1,1,1,1]);

Ireal_max=fit1.RealI_max;

fhI=figure('Name',['SW intensity along dE; peak: ',swPar.legend,' Direction: ',swPar.getTextFromVector(cutDir)]);
h1=errorbar(fit1.en,fit1.I,fit1.dI,'g');
legend(h1,'Curvature corrected intensity q<0');
% store this picture
swPar.result_pic = swPar.result_pic.place_pic(fhI,'-rize');
if exist('no_chkpts','var') && isempty(no_chkpts)
    pause
end
fit1.pic_loc=fit1.pic_loc.close_pics_all();
pause(3)

swPar.legend = swPar.getTextFromVector(bragg);
[fit2,swPar]=I_on_sw(w2,cutDir,swPar,dk,dE,1,[1,1,1,1,1]);

figure(fhI);
h2=errorbar(fit2.en,fit2.I,fit2.dI,'g');
legend([h1,h2],'Curvature corrected intensity q<0','Curvature corrected intensity q>0');
if exist('no_chkpts','var') && isempty(no_chkpts)
    pause
end
hold on;
fit2.pic_loc=fit2.pic_loc.close_pics_all();
pause(3)

Ireal_max=max(Ireal_max,fit2.RealI_max);
%


qs =[fit1.xx,fit2.xx];
es =[fit1.en,fit2.en];
q_err=[fit1.xx_err,fit2.xx_err];
IL=[fit1.I,fit2.I];
ILERR=[fit1.dI,fit2.dI];

% drop all out of sence values;
correct = IL>0 | IL<Ireal_max;
qs = qs(correct);
es = es(correct);
IL = IL(correct);
ILERR=ILERR(correct);
q_err=q_err(correct);

% drop all not satisfying the conditions
xlimit = 1.2*max(abs(qs));
ylimit = (sum(IL)/numel(IL))*(1+Imax);
correct=arrayfun(@(x,y)(abs(x)<xlimit & y<ylimit),qs,IL);
qs    = qs(correct);
es    = es(correct);
q_err = q_err(correct);
IL    = IL(correct);
ILERR = ILERR(correct);
%
parR = fit_parabola(qs,es);



xxi1=min(qs):0.01:max(qs);
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
yyi1=fitpar(xxi1,parR);

cut_id = [swPar.legend,' Direction: ',swPar.getTextFromVector(cutDir)];

fh=figure('Name',['Spin wave for: ', cut_id ]);
plot(xxi1,yyi1,['-',c1]);
plot(qs,es,c2);
swPar.result_pic = swPar.result_pic.place_pic(fh,'-rize');


i = 1:numel(qs);
err2x(3*i-2) = qs(i)-q_err(i);
err2x(3*i-1) = qs(i)+q_err(i);
err2x(3*i-0) = NaN;
err2y(3*i-2) = es(i);
err2y(3*i-1) = es(i);
err2y(3*i-0) = NaN;
q_err=[err2x;err2y];
plot(err2x,err2y,['-' c2(1)]);
minx = min(xxi1);
maxx = max(xxi1);
if minx>=maxx
    minx = -1;
    maxx = 1;
end
lx(1.5*minx,1.5*maxx);

% re-correct intensity of both SW branches accounting for new parabola
% parameters
fit1=parWithCorrections.reCorrect(fit1,swPar.p,parR);
fit2=parWithCorrections.reCorrect(fit2,swPar.p,parR);

% recorrect intensity line to plot corrected. 
[IL,ILERR] =swPar.reCorrectI(IL,ILERR,qs,parR);
[IL,IERR,en]=swPar.break_heterogeneous(IL,ILERR,es);
figure(fhI);
errorbar(en,IL,IERR,'b');

swPar.p = parR;

[IonBr1,q01,magff1] =build_IonQ(fit1,ylimit);
[IonBr2,q02,magff2] =build_IonQ(fit2,ylimit);

fh2=figure('Name',['Change of Magnetic FF along SW line for: ', cut_id ]);
plot(q01,magff1,q02,magff2);
swPar.result_pic = swPar.result_pic.place_pic(fh2,'-rize');
hold on
pause(5)


end

function [IOnQ,q0,mag_ff]=build_IonQ(fit,Imax)

[en,ind]=sort(fit.en);
I = fit.I(ind);
dI = fit.dI(ind);
q0 = fit.xx(ind);


correct = arrayfun(@(x)(x<Imax),I);
q0 = q0(correct);
I  = I(correct);
dI = dI(correct);
en = en(correct);


[I_cor,dI,mag_ff]=fix_magnetic_ff(q0,I,dI,fit.uoffset,fit.direction,fit.scale,'j2');

IOnQ = IXTdataset_1d(en,I_cor,dI);


end
