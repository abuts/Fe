function [swPar,qs,es,q_err,IonBr1,IonBr2] = fit_1SpinWave(datasource,bragg,swPar,c1,c2,no_chkpts,Imax)
%
%
% Returns:
% parR -- coefficients of the parabola approximating the spit wave
%         (p(1)+p(2)*x+p(3)*x^2)
% qs,es -- the q and E points on the spin wave where the cuts were taken
% IonBr1,IonBr2 -- the IXTdataset_1d objects of the intensity along 2 branches of the
%                  wave.
free_params = [1,1,1,1,1];
if swPar.fix_x_coordinate
    free_params = [1,0,1,1,1];
end

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
[fit1,swPar]=I_on_sw(w2,cutDir,swPar,dk,dE,-1,free_params);

Ireal_max=fit1.RealI_max;

if numel(fit1.I)>3
    fhI=figure('Name',['Curv corrected SW intensity along dE; peak: ',swPar.legend,' Direction: ',swPar.getTextFromVector(cutDir)]);
    h1=errorbar(fit1.en,fit1.I,fit1.dI,'g');
    legend(h1,'Curvature corrected intensity q<0');
    % store this picture
    swPar.result_pic = swPar.result_pic.place_pic(fhI,'-rize');
    if exist('no_chkpts','var') && isempty(no_chkpts)
        pause
    end
    fit1.pic_loc=fit1.pic_loc.close_pics_all();
    pause(3)
end

swPar.legend = swPar.getTextFromVector(bragg);
[fit2,swPar]=I_on_sw(w2,cutDir,swPar,dk,dE,1,free_params);

if numel(fit1.I)>3
    figure(fhI);
    h2=errorbar(fit2.en,fit2.I,fit2.dI,'g');
    legend([h1,h2],'Curvature corrected intensity q<0','Curvature corrected intensity q>0');
    if exist('no_chkpts','var') && isempty(no_chkpts)
        pause
    end
    hold on;
end
Ireal_max=max(Ireal_max,fit2.RealI_max);
parOld = swPar.p;
parR   = parOld;
cut_id = [swPar.legend,' Direction: ',swPar.getTextFromVector(cutDir)];
qs =[fit1.xx,fit2.xx];
es =[fit1.en,fit2.en];
if swPar.cut_at_e_points
    q_err=ones(numel(qs),1);
else
    q_err=[fit1.xx_err,fit2.xx_err];
end
IL=[fit1.I,fit2.I];
ILERR=[fit1.dI,fit2.dI];

ylimit = max(IL)*1.1;
if numel(fit1.I)>5
    ly(0, 1.2*Ireal_max);
    
    fit2.pic_loc=fit2.pic_loc.close_pics_all();
    pause(3)
    
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
    if swPar.fix_x_coordinate
        parR = swPar.p;
    else
        parR = fit_parabola(qs,es,q_err);
    end
    disp([' SW at', cut_id,' fitting parameters:']);
    disp(parR)
    
    parOld = swPar.p;
    swPar.p = parR;
    xxi1=min(qs):0.01:max(qs);
    yyi1=swPar.dispersion(xxi1);  
    
    
    fh=figure('Name',['Spin wave for: ', cut_id ]);
    plot(xxi1,yyi1,['-',c1]);
    hold on
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
    fit1=swPar.reCorrect(fit1,parOld,parR);
    fit2=swPar.reCorrect(fit2,parOld,parR);
    
    % recorrect intensity line to plot corrected.
    [IL,ILERR] =swPar.reCorrectI(IL,ILERR,qs,parOld,parR);
    [IL,IERR,en]=swPar.break_heterogeneous(IL,ILERR,es);
    figure(fhI);
    errorbar(en,IL,IERR,'b');
end
% redefine initial reference points according to spin wave fittied to all
% points
[ref_points,swPar]=swPar.refit_ref_points(parR);
disp([' SW at', cut_id,' reference points \n'])
disp(ref_points)

% here we fit magnetic form factor.
[IonBr1,q01,magff1,avrg_MFF1,I12plot,dI12plot,en1] =build_IonQ(fit1,ylimit);
[IonBr2,q02,magff2,avrg_MFF2,I22plot,dI22plot,en2] =build_IonQ(fit2,ylimit);

if numel(fit1.I)>3
    avrg_MFF = 0.5*(avrg_MFF1+avrg_MFF2);
    I12plot   = I12plot*avrg_MFF;
    dI12plot  = dI12plot*avrg_MFF;
    I22plot   = I22plot*avrg_MFF;
    dI22plot  = dI22plot*avrg_MFF;
    
    
    fh2=figure('Name',['Change of Magnetic FF along SW line for: ', cut_id ]);
    plot(q01,magff1,q02,magff2);
    swPar.result_pic = swPar.result_pic.place_pic(fh2,'-rize');
    hold on
    % plot intensity corrected by magnetic form factor
    
    Ip = [I12plot,I22plot];
    dIp=[dI12plot,dI22plot];
    eplot = [en1,en2];
    [Ip,dIp,en]=swPar.break_heterogeneous(Ip,dIp,eplot);
    figure(fhI);
    h3= errorbar(en,Ip,dIp,'k');
    leg3= sprintf('MagFF-corrected intensity multiplied by %4.2f',avrg_MFF);
    legend([h1,h2,h3],'Curve corrercted intensity','Curve corrercted intensity refit by sw par',leg3);
    
    pause(5)
else
    disp('      q       En      I_qCorr   Error__qCor   magff1');
    for i=1:numel(magff1)
        disp([fit1.xx(i),fit1.en(i),fit1.I(i),fit1.dI(i),magff1(i)]);
    end
    for i=1:numel(magff2)
        disp([fit2.xx(i),fit2.en(i),fit2.I(i),fit2.dI(i),magff2(i)]);
    end
end

end

function [IOnQ,q0,mag_ff,avrgMFF,I_cor,dI,en]=build_IonQ(fit,Imax)

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
avrgMFF = sum(mag_ff)/numel(mag_ff);

IOnQ = IXTdataset_1d(en,I_cor,dI);

end
