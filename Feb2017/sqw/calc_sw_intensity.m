function [D,x0,alpha,e_sw,Icr,dIcr,all_plots]=calc_sw_intensity(data_source,bragg,cut_direction,cut_p,dE,dK)
% Make range of 1D cuts, fits them with gaussian and found gaussian
% parameters, fit Gaussian maxima positions with parabola 
% and found parameters of this parabola.
% Estimante intensity along parabola from Gaussian fit amplitude and
% correct this intensity by cut properties, dependent on SW curvature 
%Inputs:
% data_source -- full path and name of the sqw file to cut
% bragg       -- hkl coordinates of bragg peak to cut around
% cut_directio-- hkl vector pointing to the cut direction with central
%                point of bragg
% cut_p       -- array of Q-dE points along cut direction to do 1D cuts
%                around
% dE          -- half of energy resolution of the cut 
% dK          -- half of q-resolution of the cut.
%
free_params = [1,1,1,1,1];

q_sw = cut_p(:,1);
e_sw = cut_p(:,2);

%-------------------------------------------------
% Projection
Kr = [-1,0.5*dK,1];
proj.type = 'ppp';
proj.uoffset = bragg;
[proj.u,proj.v,proj.w]=make_ortho_set(cut_direction);

%-------------------------------------------------
% 2D cut to investigate further:
w2 = cut_sqw(data_source,proj,Kr,[-dK,+dK],[-dK,+dK],dE);
%
plot(w2);
lz 0 2
hold on
% remember the place of the last image and place the impage to proper
% posision
mff = MagneticIons('Fe0');
w2=mff.fix_magnetic_ff(w2);
pl1=plot(w2);
lz 0 4
hold on
%-------------------------------------------------
%
peak_width = 0.2;

Intenc = ones(9,numel(q_sw)).*NaN;
for i=1:size(cut_p,1)
    if isnan(q_sw(i)); continue
    end
    
    [k_min,k_max,dk_cut] = q_range(q_sw(i),e_sw(i),dK);
    w1=cut_sqw(w2,proj,[k_min,dk_cut,k_max],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
    %-------
    w0=cut_sqw(w2,proj,[q_sw(i)-dK,q_sw(i)+dK],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
    IP=w0.data.s;
    dIP = w0.data.e;
    [fw1,par]=fit(w1,@gaussIbkgd,[IP,q_sw(i),peak_width,0.01,0],free_params);
    
    acolor('k')    
    pl2=plot(w1);
    acolor('r')
    pd(fw1);
    drawnow;
    %sigma=abs(par.p(3));
    ig = uint32(I_types.I_gaus_fit);   Intenc(ig,i) = par.p(1); %par.p(1)*sigma*sqrt(2*pi);
    id = uint32(I_types.dI_gaus_fit);  Intenc(id,i) = par.sig(1);
    i0 = uint32(I_types.gaus_sig);     Intenc(i0,i) = par.p(3);
    ix = uint32(I_types.gaus_x0);      Intenc(ix,i) = par.p(2);    
    dix= uint32(I_types.gaus_dx0);     Intenc(dix,i)= par.sig(2);        
    
    ii = uint32(I_types.I_cut);     Intenc(ii,i)  =IP;
    di = uint32(I_types.dI_cut);    Intenc(di,i)  =dIP;
end
%
I   = Intenc(uint32(I_types.I_cut),:);
dI  = Intenc(uint32(I_types.dI_cut),:);
Iaf = Intenc(uint32(I_types.I_gaus_fit),:);
dIaf= Intenc(uint32(I_types.dI_gaus_fit),:);
%---------------------------------------------------------------
caption =@(vector)['[' num2str(vector(1)) ',' num2str(vector(2)) ',' num2str(vector(3)) ']'];
% Plot all intensities as processed
pl3=figure('Name',['SW intensity along dE; peak: ',caption(bragg),' Direction: ',caption(cut_direction)]);
li1=errorbar(e_sw,I,dI,'b');
hold on
li2=errorbar(e_sw,Iaf,dIaf,'r');
%
plots = [li1, li2];
ly 0 2
legend(plots,'Integral intensity','Gaussian fitted intensity');
%---------------------------------------------------------------
% Fit and plot spin-wave shape
qswm = Intenc(uint32(I_types.gaus_x0),:);
qswm_err =Intenc(uint32(I_types.gaus_dx0),:); 

parab = @(x,par)(par(1)+(par(2)+par(3)*x).*x);
s.x = qswm;
s.y = e_sw';
s.e = qswm_err;
[~,fit_par] = fit(s,parab,[1,1,1]);
parR  = fit_par.p;

xxpf=min(qswm):0.01:max(qswm);
yypf=parab(xxpf,parR);

cut_id = [caption(bragg),' Direction: ',caption(cut_direction)];
pl4=figure('Name',['Spin wave for: ', cut_id ]);
plot(xxpf,yypf,['-','g']);
hold on
errorbar(qswm,e_sw,qswm_err,'r');
%---------------------------------------------------------------
D = parR(3);
x0 =parR(1);
alpha = parR(2);
% recorrect intensity according to the new parabola params and plot it
Icr = Iaf.*(2*D*abs(qswm));
dIcr= dIaf.*(2*D*abs(qswm));
pl5=figure('Name',['Corrected SW intensity along dE; peak: ',caption(bragg),' Direction: ',caption(cut_direction)]);
ple=errorbar(e_sw,Icr,dIcr,'g');
%
ly 50 300
legend(ple,['SW Intensity, dE: ',num2str(2*dE),' dk: ',num2str(2*dK)]);

all_plots = [pl1,pl2,pl3,pl4,pl5];

%
function y = gaussIbkgd(x, p, varargin)

y=exp(-0.5*((x-p(2))/p(3)).^2)*(p(1)/sqrt(2*pi)/p(3)) + (p(4)+x*p(5));

function [u,v,w,Norm]=make_ortho_set(u)
% simple function which generate orthogonal right-hand set around
% specified vector

Rot=zeros(3,3,3);
% Rx
Rot(1,1,1)=1;
Rot(2,3,1)=-1;
Rot(3,2,1)=1;
% Ry
Rot(1,3,2)=-1;
Rot(2,2,2)= 1;
Rot(3,1,2)= 1;
%Rz
Rot(3,3,3)=1;
Rot(1,2,3)=-1;
Rot(2,1,3)=1;

[minv,im] = min(abs(u));

Norm = sqrt(u*u');
if Norm<1.e-6
    error('MAKE_ORTHO_SET:invalid_argument',' u can not be 0 vectror')
end

u = u/Norm; %;
wt = (Rot(:,:,im)*u')';
vt = cross(wt,u);
v = vt/sqrt(vt*vt');

w = cross(u,v);


function [mina,maxa,dk_cut] = q_range(q,energy,dk)
% method calculates the q-range to make cut within.
Esw_threshold = 40;
num_steps_in_cut = 20;
qrange= 0.2;
if energy>Esw_threshold  % limits for phonons
    q_min = q*2.5;
    q_max = 0;
else
    q_min = q-qrange;
    q_max = q+qrange;
end

a = [q_min,q_max];
mina = min(a);
maxa = max(a);

if 0.5*(mina+maxa) > 0
    if mina < 0
        mina = 0;
    end
else
    if maxa > 0
        maxa  = 0;
    end
end

n_steps = (maxa-mina)/dk;
if n_steps<num_steps_in_cut
    dk_cut = (maxa-mina)/num_steps_in_cut;
else
    dk_cut = dk;
end

