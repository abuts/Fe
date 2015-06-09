function [fit_rez,parWithCorr] = I_on_sw(w2,u,parWithCorr,dk,dE,s,free_par)
%Calculate "exact" speen wave dispersion curve on the basis of approximated
%(parabolic) shape and the intensity of a speen wave along the dispersion
%curve on the basis of gaussian with background fittng
%
%

% the parameters of the parabola, obtained from
%[ff1,t]=fit(w2p1,@(x,y,p)(p(1).*exp(-p(2)*abs(y-p(3)*x.^2))),[0.2,0.1,140/0.37])
% % for Ei=200,z=(2,0,0) u=0,1,0
%p=[ 0.2807 0.0284 966.4318];
%u = [0,0,1];
% for Ei=200,z=(1,1,0)
%p = [ 0.0    0.0  966.0];

y_cut = 0;
%
[proj.u,proj.v,proj.w]=make_ortho_set(u);
proj.type = 'ppp';
proj.uoffset= w2.data.uoffset;
fit_rez.uoffset = proj.uoffset;
fit_rez.scale   = w2.data.ulen;
fit_rez.direction = u;


if parWithCorr.cut_at_e_points
    e_sw  = parWithCorr.energies;
    xx    = parWithCorr.getXonE(e_sw,s);
    valid = parWithCorr.evalid(e_sw,s);
    e_sw  =e_sw(valid);
    xx  = xx(valid);
    pic_loc=pic_spread();        
else
    e_min=parWithCorr.emin(s);
    e_max=parWithCorr.emax(s);
    e_sw = e_min+dE:2*dE:e_max-dE;
    xx = parWithCorr.getXonE(e_sw,s);
    pic_loc=pic_spread('-tight');    
end
% initial peak width
width = parWithCorr.peak_width;



I = zeros(1,numel(xx));
x1=zeros(1,numel(xx));
x1_err=zeros(1,numel(xx));
I_area_fit= zeros(1,numel(xx));
I_area_fitCor=zeros(1,numel(xx));
dI_area_fitCor=zeros(1,numel(xx));
dI= zeros(1,numel(xx));
dI_area_fit= zeros(1,numel(xx));
sigma_arr=zeros(1,numel(xx));

for i=1:numel(xx)
    if e_sw(i)<y_cut
        I(i)=NaN;
        dI(i)=NaN;
        continue
    end
    [k_min,k_max,dk_cut] = parWithCorr.q_range(xx(i),e_sw(i),dk);
    
    
    try
        w1=cut_sqw(w2,proj,[k_min,dk_cut,k_max],[-dk,dk],[-dk,dk],[e_sw(i)-dE,e_sw(i)+dE]);
    catch
        I_area_fit(i)=NaN;
        dI_area_fit(i)=NaN;
        x1(i) = xx(i);
        x1_err(i) = 0;
        continue
    end
    
    
    acolor('k')
    h=plot(w1);
    pic_loc=pic_loc.place_pic(h);
    
    try
        w0=cut_sqw(w2,proj,[xx(i)-dk,xx(i)+dk],[-dk,dk],[-dk,dk],[e_sw(i)-dE,e_sw(i)+dE]);
    catch
    end
    
    IP=w0.data.s;
    
    
    [fw1,par]=fit(w1,@gaussIbkgd,[IP,xx(i),width,0.01,0],free_par);
    acolor('r')
    pd(fw1);
    
    x1(i) = par.p(2);
    x1_err(i) = par.sig(2);
    try
        w0=cut_sqw(w2,proj,[x1(i)-dk,x1(i)+dk],[-dk,dk],[-dk,dk],[e_sw(i)-dE,e_sw(i)+dE]);
    catch
    end
    
    I(i)=w0.data.s;
    dI(i) = w0.data.e;

    
    keep_figure;
    drawnow;
    
    sigma=abs(par.p(3));
    I_area_fit(i) = par.p(1); %par.p(1)*sigma*sqrt(2*pi);
    sigma_arr(i)=sigma;
    %disp(['Sigma =' num2str(sigma)]);
    if I_area_fit(i) >0 && ~all(par.sig==0)
        dI_area_fit(i) = par.sig(1); %(par.sig(1)*sigma+par.sig(3)*par.p(1))*sqrt(2*pi);
        [I_area_fitCor(i),dI_area_fitCor(i)] = parWithCorr.correctIntensity(I_area_fit(i),dI_area_fit(i),x1(i),sigma,dk,dE);                
    else
        I_area_fit(i) = NaN;
        I_area_fitCor(i)=NaN;
        dI_area_fit(i)= NaN;
    end
    
end
corect = ~isnan(I)&(~isnan(I_area_fit));

xx = xx(corect);
e_sw=e_sw(corect);
I = I(corect);
x1=x1(corect);
x1_err=x1_err(corect);
I_area_fit= I_area_fit(corect);
I_area_fitCor=I_area_fitCor(corect);
dI_area_fitCor=dI_area_fitCor(corect);
dI= dI(corect);
dI_area_fit=dI_area_fit(corect);
sigma_arr=sigma_arr(corect);

corect = parWithCorr.filter_error(x1_err) | parWithCorr.filter_error(dI);
xx = xx(corect);
e_sw=e_sw(corect);
I = I(corect);
x1=x1(corect);
x1_err=x1_err(corect);
I_area_fit= I_area_fit(corect);
I_area_fitCor=I_area_fitCor(corect);
dI_area_fitCor=dI_area_fitCor(corect);
dI= dI(corect);
dI_area_fit=dI_area_fit(corect);
sigma_arr=sigma_arr(corect);



if numel(xx)>3
    f1=figure('Name',['SW intensity along dE; peak: ',parWithCorr.legend,' Direction: ',parWithCorr.getTextFromVector(u)]);
    %branch1=IXTdataset_1d(e_sw,I,dI);
    %plot(branch1)
    pl1=errorbar(e_sw,I,dI,'b');
    hold on
    %branch2=IXTdataset_1d(e_sw,I_area_fit,dI_area_fit);
    %plot(branch2)
    pl2=errorbar(e_sw,I_area_fit,dI_area_fit,'r');
    %
    scale = max(I_area_fitCor)/2;
    I_area_fitpCor = I_area_fitCor/scale;
    dIpCor = dI_area_fitCor/scale;
    pl3=errorbar(e_sw,I_area_fitpCor,dIpCor,'g');
    plots = [pl1, pl2, pl3];
    ly 0 5
    leg3= sprintf('curvature-corrected intensity divided by %4.2f',scale);
    legend(plots,'Integral intensity','Gaussian fitted intensity',leg3);
    parWithCorr.result_pic=parWithCorr.result_pic.place_pic(f1,'-rize');
else
    disp('      q       En      I_areaFit,    I_Err   I_qCorr   Error__qCor');
    for i=1:numel(xx)
        disp([xx(i),e_sw(i),I_area_fit(i),dI(i),I_area_fitCor(i),dI_area_fitCor(i)]);
    end
end
fit_rez.xx=x1;
fit_rez.xx_err=x1_err;
fit_rez.en=e_sw;
fit_rez.I = I_area_fitCor;
fit_rez.dI = dI_area_fitCor;
fit_rez.pic_loc=pic_loc;
[mv,ind] = max(I_area_fit);
fit_rez.RealI_max = parWithCorr.correctIntensity(mv,1,x1(ind),sigma_arr(ind),dk,dE);


function y = gaussIbkgd(x, p, varargin)

y=exp(-0.5*((x-p(2))/p(3)).^2)*(p(1)/sqrt(2*pi)/p(3)) + (p(4)+x*p(5));


