function [fit_rez,parWithCorr] = I_on_sw2Peak(w2,u,parWithCorr,dk,dE,s,free_par)
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
% % for Ei=400,z=(1,1,0)
% p = [0.3556    0.0082  905.1404];
% % for Ei=400,z=(2,0,0)
% p=[0.1676    0.0087  918.6542];
% % for Ei=800,z=(2,0,0)
% p=[0.1053    0.0043  794.2148];
% for Ei=800,z=(1,1,0)
%p=[0.1856    0.0032  886.8619];
% % for Ei=1400,z=(1,1,0)
%p=[0.2869  0.0059  1.2319e+03];
%
% % for Ei=200, z=2,0,0
% u=[1,1,0]
% p=[0.2042    0.0248  748.3035];
e_min=parWithCorr.emin(0);
e_max=parWithCorr.emax(0);
e_sw = e_min+dE:2*dE:e_max-dE;
xx = parWithCorr.getXonE(e_sw,-1);
% initial peak width
width = parWithCorr.peak_width;



[proj.u,proj.v,proj.w]=make_ortho_set(u);
proj.type = 'ppp';
proj.uoffset= w2.data.uoffset;
fit_rez.uoffset = proj.uoffset;
fit_rez.scale   = w2.data.ulen;
fit_rez.direction = u;



I = zeros(1,numel(xx));
x1=zeros(1,numel(xx));
x1_err=zeros(1,numel(xx));
I1= zeros(1,numel(xx));
I1cor=zeros(1,numel(xx));
dI1cor=zeros(1,numel(xx));
dI= zeros(1,numel(xx));
dI1= zeros(1,numel(xx));
pic_loc=pic_spread('-tight');
sigma_arr=zeros(1,numel(xx));

for i=1:numel(xx)
    if e_sw(i)<y_cut
        I(i)=NaN;
        dI(i)=NaN;
        continue
    end
    [k_min,k_max,dk_cut] = parWithCorr.q_range(xx(i),e_sw(i),dk,'sym');
    
    
    try
        w1=cut_sqw(w2,proj,[k_min,dk_cut,k_max],[-dk,dk],[-dk,dk],[e_sw(i)-dE,e_sw(i)+dE]);
    catch
        I1(i)=NaN;
        dI1(i)=NaN;
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
    
    
    [fw1,par]=fit(w1,@gauss2PeakIbkgd,[IP,xx(i),width,0.01,0],free_par);
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
    
    
    sigma=abs(par.p(3));
    I1(i) = par.p(1)*sigma*sqrt(2*pi);
    sigma_arr(i)=sigma;
    %disp(['Sigma =' num2str(sigma)]);
    if I1(i) >0
        dI1(i) = par.sig(1); %(par.sig(1)*sigma+par.sig(3)*par.p(1))*sqrt(2*pi);
        [I1cor(i),dI1cor(i)] = parWithCorr.correctIntensity(I1(i),dI1(i),x1(i),sigma,dk,dE);                
    else
        I1(i) = NaN;
        I1cor(i)=NaN;
        dI1(i)= NaN;
    end
    
end
f1=figure('Name',['SW intensity along dE; peak: ',parWithCorr.legend,' Direction: ',parWithCorr.getTextFromVector(u)]);
%branch1=IXTdataset_1d(e_sw,I,dI);
%plot(branch1)
pl1=errorbar(e_sw,I,dI,'b');
hold on
%branch2=IXTdataset_1d(e_sw,I1,dI1);
%plot(branch2)
pl2=errorbar(e_sw,I1,dI1,'r');
%
scale = max(I1cor)/2;
I1pCor = I1cor/scale;
dIpCor = dI1cor/scale;
pl3=errorbar(e_sw,I1pCor,dIpCor,'g');
plots = [pl1, pl2, pl3];
ly 0 5
leg3= sprintf('curvature-corrected intensity divided by %4.2f',scale);
legend(plots,'Integral intensity','Gaussian fitted intensity',leg3);
parWithCorr.result_pic=parWithCorr.result_pic.place_pic(f1,'-rize');
fit_rez.xx=x1;
fit_rez.xx_err=x1_err;
fit_rez.en=e_sw;
fit_rez.I = I1cor;
fit_rez.dI = dI1cor;
fit_rez.pic_loc=pic_loc;
[mv,ind] = max(I);
fit_rez.RealI_max = parWithCorr.correctIntensity(mv,1,x1(ind),sigma_arr(ind),dk,dE);


function y = gaussIbkgd(x, p, varargin)

y=exp(-0.5*((x-p(2))/p(3)).^2)*(p(1)/sqrt(2*pi)/p(3)) + (p(4)+x*p(5));


