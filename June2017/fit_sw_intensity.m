function [D,x0,alpha,e_sw,Amp_pl,fhhw_pl,all_plots]=fit_sw_intensity(data_source,bragg,cut_direction,cut_p,dE,dK)
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
fwhh = 0.2;
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

w2 = set_sample_and_inst(w2,sample,@maps_instrument_for_tests,'-efix',600,'S');



D1FitRez = ones(9,numel(q_sw)).*NaN;
w_list = repmat(sqw,size(cut_p,1),1);
ws_valid = false(size(cut_p,1),1);
for i=1:size(cut_p,1)
    if isnan(q_sw(i))
        continue
    else
        ws_valid(i) = true;
    end
    
    [k_min,k_max,dk_cut] = q_range(q_sw(i),e_sw(i),dK);
    w1=cut_sqw(w2,proj,[k_min,dk_cut,k_max],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
    %-------
    w0=cut_sqw(w2,proj,[q_sw(i)-dK,q_sw(i)+dK],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
    
    
    
    const = w1.data.s(1); % take background as the intencity at leftmost point
    grad  = 0;  % guess background gradient is 0
    amp=(w0.data.s-const)*(k_max-k_min); % guess gausian amplitude
    
    ii = uint32(I_types.I_cut);     D1FitRez(ii,i)  =amp;
    di = uint32(I_types.dI_cut);    D1FitRez(di,i)  =w0.data.e*(k_max-k_min);
    
    
    %[fw1,par]=fit(w1,@gaussIbkgd,[IP,q_sw(i),peak_width,0.01,0],free_params);
    
    kk = tobyfit2(w1);
    kk = kk.set_fun(@(h,k,l,e,par)gauss_shape(proj,h,k,l,e,par),[amp,q_sw(i),fwhh],[1,1,1]);
    %kk = kk.set_free([1,0,0]);
    kk = kk.set_bfun(@lin_bg,[const,grad]);
    %kk = kk.set_bfree([1,0]);
    
    kk = kk.set_mc_points(10);
    kk = kk.set_options('listing',1);
    %[w1_tf, fp3] = kk.simulate;
    [w1_tf,fp3]=kk.fit;
    w_list(i) = w1;
    if fp3.converged && fp3.chisq < 1.9
        ig = uint32(I_types.I_gaus_fit);   D1FitRez(ig,i) = fp3.p(1); %par.p(1)*sigma*sqrt(2*pi);
        i0 = uint32(I_types.gaus_sig);     D1FitRez(i0,i) = fp3.p(3);
        ix = uint32(I_types.gaus_x0);      D1FitRez(ix,i) = fp3.p(2);
        id = uint32(I_types.dI_gaus_fit);  D1FitRez(id,i) = fp3.sig(1);
        dix= uint32(I_types.gaus_dx0);     D1FitRez(dix,i)= fp3.sig(2);
    end
    
    
    acolor('k')
    pl2=plot(w1);
    acolor('r')
    pd(w1_tf);
    drawnow;
end
w_list = w_list(ws_valid);
%
I   = D1FitRez(uint32(I_types.I_cut),:);
dI  = D1FitRez(uint32(I_types.dI_cut),:);
Iaf = D1FitRez(uint32(I_types.I_gaus_fit),:);
dIaf= D1FitRez(uint32(I_types.dI_gaus_fit),:);
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
legend(plots,'Integral intensity','Tobyfit2 intensity');
%---------------------------------------------------------------
% Fit and plot spin-wave shape
valid = ~isnan(D1FitRez(uint32(I_types.gaus_sig),:));

qswm = D1FitRez(uint32(I_types.gaus_x0),valid);
qswm_err =D1FitRez(uint32(I_types.gaus_dx0),valid );

parab = @(x,par)(par(1)+(par(2)+par(3)*x).*x);
s.x = qswm;
s.y = e_sw(valid)';
s.e = qswm_err;
[~,fit_par] = fit(s,parab,[1,1,1]);
parR  = fit_par.p;

xxpf=min(qswm):0.01:max(qswm);
yypf=parab(xxpf,parR);

cut_id = [caption(bragg),' Direction: ',caption(cut_direction)];
pl4=figure('Name',['Spin wave for: ', cut_id ]);
plot(xxpf,yypf,['-','g']);
hold on
ind    = find(valid);
qswm_err_l = ones(numel(valid),1)*NaN;
qswm_err_l(ind(:))= qswm_err(:);
errorbar(q_sw,e_sw,qswm_err_l,'r');
errorbar(qswm,e_sw(valid),D1FitRez(uint32(I_types.gaus_sig),valid),'b');



fhhw_all  = D1FitRez(uint32(I_types.gaus_sig),valid);
ampl = D1FitRez(uint32(I_types.I_gaus_fit),valid);
ampl_avrg = sum(ampl)/sum(valid);
fwhh_avrg = sum(fhhw_all)/sum(valid);
deltaSq = sum((fhhw_all - fwhh_avrg).^2)/sum(valid);
deltaASq  = sum((ampl    - ampl_avrg).^2)/sum(valid);
fprintf('Av_amplitude: %f +-%f; Full height Half width average: %f +- %f\n',...
    ampl_avrg,sqrt(deltaASq),fwhh_avrg,sqrt(deltaSq));

kk = tobyfit2(w_list);
%kk = kk.set_local_foreground(true);
kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg]);
%kk = kk.set_bind(1,1,1);
%kk = kk.set_bind(2,2,1);
%kk = kk.set_bind(3,3,1);
kk = kk.set_bfun(@lin_bg,[const,grad]);
kk = kk.set_mc_points(10);
kk = kk.set_options('listing',1);
[w110arr1_tf,fp110arr1]=kk.fit;

fitpar = reshape([fp110arr1.p{:}],5,numel(fp110arr1.p))';
fiterr = reshape([fp110arr1.sig{:}],5,numel(fp110arr1.sig))';
%fback = kk.simulate(w110arr1_tf,'back');
%pl(fback)
Amp    = fitpar(:,4);
Amp_err= fiterr(:,4);
fhhw   = fitpar(:,5);
%fhhw_err=fiterr(:,5);
ind    = find(ws_valid);
Amp_pl = ones(numel(ws_valid),1)*NaN;
Amp_pl_err = Amp_pl;
fhhw_pl    = Amp_pl;

Amp_pl(ind(:)) = Amp(:);
Amp_pl_err(ind(:)) = Amp_err(:);


figure('Name',['Tobyfitted SW intensity along dE; peak: ',caption(bragg),' Direction: ',caption(cut_direction)]);
errorbar(e_sw,Amp_pl,Amp_pl_err,'r');
%
%ly 0 2
%legend(li2,'Tobifitted intensity','Tobyfit2 intensity')

xxpf=min(qswm):0.01:max(qswm);
par_sw = fp110arr1.p{1}(1:3);
yypf=parab(xxpf,par_sw);

figure('Name',['Spin wave for: ', cut_id ]);
plot(xxpf,yypf,['-','g']);
hold on
fhhw_pl(ind(:)) = fhhw(:);
errorbar(q_sw,e_sw,fhhw_pl,'b');

%---------------------------------------------------------------
D = par_sw(3);
x0 =par_sw(1);
alpha = par_sw(2);
% % recorrect intensity according to the new parabola params and plot it
% Icr = Iaf.*(2*D*abs(qswm));
% dIcr= dIaf.*(2*D*abs(qswm));
% pl5=figure('Name',['Corrected SW intensity along dE; peak: ',caption(bragg),' Direction: ',caption(cut_direction)]);
% ple=errorbar(e_sw,Icr,dIcr,'g');
% %
% ly 50 300
% legend(ple,['SW Intensity, dE: ',num2str(2*dE),' dk: ',num2str(2*dK)]);
% 
all_plots = [pl1,pl2,pl3,pl4,pl5];

%
function y = gauss_shape(proj,qh,qk,ql,en,pars)

ampl=pars(1);
sig=pars(3)/sqrt(log(256));
h0 =  proj.uoffset(1)+pars(2)*proj.u(1);
k0 =  proj.uoffset(2)+pars(2)*proj.u(2);
l0 =  proj.uoffset(3)+pars(2)*proj.u(3);

x2 = ((qh-h0).^2+(qk-k0).^2+(ql-l0).^2);
y=exp(-x2/(2*sig*sig))*(ampl/sqrt(2*pi)/sig);


function y = sw_disp(proj,qh,qk,ql,en,pars)


D2 = pars(3);
E0 = pars(1);
if(E0<0)
    E0 = -E0;
    hand = true;
else
    hand = false;
end
q0 = sqrt((en-E0)/D2);

if proj.u(1)>0
    qhp2 = (qh - proj.uoffset(1)-q0*proj.u(1)).^2;
    qhm2 = (qh - proj.uoffset(1)+q0*proj.u(1)).^2;
    qh2 = min(qhp2,qhm2);
else
    qh2 = (qh - proj.uoffset(1)-q0*proj.u(1)).^2;
end
if proj.u(2)>0
    qkp2 = (qk - proj.uoffset(2)-q0*proj.u(2)).^2;
    qkm2 = (qk - proj.uoffset(2)+q0*proj.u(2)).^2;
    qk2 = min(qkp2,qkm2);
else
    qk2 = (qk - proj.uoffset(2)-q0*proj.u(2)).^2;
end
if proj.u(3)>0
    qlp2 = (ql - proj.uoffset(3)-q0*proj.u(3)).^2;
    qlm2 = (ql - proj.uoffset(3)+q0*proj.u(3)).^2;
    ql2 = min(qlp2,qlm2);
else
    ql2 = (ql - proj.uoffset(3)-q0*proj.u(3)).^2;
end

x2 = (qh2+qk2+ql2);

ampl = pars(4);
sig=pars(5)/sqrt(log(256));
y=exp(-x2/(2*sig*sig))*(ampl/sqrt(2*pi)/sig);
if hand
    y = y+E0*sum(y)*10;
end



function bg = lin_bg(x,par)
%
bg  = par(1)+x*par(2);

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

