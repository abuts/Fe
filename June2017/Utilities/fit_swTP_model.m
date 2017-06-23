function [result,all_plots]=fit_swTP_model(data_source,bragg,cut_direction,cut_p,dE,dK)
% Make range of 1D cuts, fits them with TF models and found model
% parameters, fit Gaussian maxima positions with parabola
% Estimate intensity along sw  from Gaussian fit amplitude and
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

q_range = cut_p(:,1);
e_sw = cut_p(:,2);
result = struct();

%-------------------------------------------------
% Projection
Kr = [-1,0.5*dK,1];
proj.type = 'ppp';
proj.uoffset = bragg;
[proj.u,proj.v,proj.w]=make_ortho_set(cut_direction);

%-------------------------------------------------
% 2D cut to investigate further:
w2 = cut_sqw(data_source,proj,Kr,[-dK,+dK],[-dK,+dK],0.2*dE);
%
%figure;
pl1=plot(w2);
lz 0 2
ly 0 180
hold on
% remember the place of the last image and place the impage to proper
% posision
mff = MagneticIons('Fe0');
%w2=mff.fix_magnetic_ff(w2);
% pl1=plot(w2);
% lz 0 4
% hold on
%-------------------------------------------------
%
fwhh = 0.1;
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

w2 = set_sample_and_inst(w2,sample,@maps_instrument_for_tests,'-efix',600,'S');



D1FitRez = ones(8,numel(q_range)).*NaN;
cut_list = repmat(sqw,size(cut_p,1),1);
ws_valid = false(size(cut_p,1),1);
for i=1:size(cut_p,1)
    if isnan(q_range(i)) || isnan(e_sw(i))
        continue
    else
        ws_valid(i) = true;
    end
    if e_sw(i) <= 40
        width = 5;
    else
        width = 8;        
    end
    
    k_min = -q_range(i)-width*dK;
    k_max =  q_range(i)+width*dK;
    try
        w1=cut_sqw(w2,proj,[k_min,0.2*dK,k_max],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
        w0=cut_sqw(w2,proj,[-dK+q_range(i),dK+q_range(i)],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
        w1f = mff.correct_mag_ff(w1);
        w0  = mff.correct_mag_ff(w0);
    catch Err
        disp([' Cut rejected, ',Err.message]);
        ws_valid(i) = false;
        continue
    end
    %-------
    
    
    
    const = w1.data.s(1); % take background as the intencity at leftmost point
    grad  = 0;  % guess background gradient is 0
    amp=(w0.data.s-const); % guess gausian amplitude
    
    ic = uint32(I_types.I_cut);     D1FitRez(ic,i)  =amp;
    di = uint32(I_types.dI_cut);    D1FitRez(di,i)  =w0.data.e*(k_max-k_min);
    
    IP=amp;
    %dIP = w0.data.e;
    peak_width = fwhh*sqrt(log(256));
    try
        [w1_tf,fp3]=fit(w1f,@TwoGaussAndBkgd,...
            [IP,q_range(i),peak_width,const,grad],[1,1,1,1,1],'fit',[1.e-4,40,1.e-6]);
    catch
        ws_valid(i) = false;
        continue
        
    end
    
    
    %kk = tobyfit2(w1);
    %ff_calc = mff.getFF_calculator(w1);
    
    %kk = kk.set_fun(@(h,k,l,e,par)gauss_shape(proj,ff_calc,h,k,l,e,par),[amp,q_sw(i),fwhh],[1,1,1]);
    %kk = kk.set_free([1,0,0]);
    %kk = kk.set_bfun(@lin_bg,[const,grad]);
    %kk = kk.set_bfree([1,0]);
    
    %kk = kk.set_mc_points(10);
    %kk = kk.set_options('listing',1);
    %[w1_tf, fp3] = kk.simulate;
    %[w1_tf,fp3]=kk.fit;
    cut_list(i) = w1;
    if fp3.converged && fp3.chisq < 4 && ~any(isnan(fp3.sig))
        ig = uint32(I_types.I_gaus_fit);   D1FitRez(ig,i) = fp3.p(1); %par.p(1)*sigma*sqrt(2*pi);
        i0 = uint32(I_types.gaus_sig);     D1FitRez(i0,i) = fp3.p(3);
        ix = uint32(I_types.gaus_x0);      D1FitRez(ix,i) = fp3.p(2);
        id = uint32(I_types.dI_gaus_fit);  D1FitRez(id,i) = fp3.sig(1);
        dix= uint32(I_types.gaus_dx0);     D1FitRez(dix,i)= fp3.sig(2);
        bg1= uint32(I_types.bkg_level);    D1FitRez(bg1,i)= fp3.p(4);
        bg2= uint32(I_types.bkg_grad);     D1FitRez(bg2,i)= fp3.p(5);
        cross = false;
    else
        cross = true;
    end
    
    
    acolor('k')
    pl2=plot(w1f);
    acolor('r')
    pd(w1_tf);
    if cross
        hold on
        y_min = min( w1.data.s);
        y_max = max(w1.data.s);
        line([k_min,k_max],[y_min ,y_max ],'Color','r','LineWidth',2)
        line([k_min,k_max],[y_max, y_min ],'Color','r','LineWidth',2)
        hold off
    end
    
    drawnow;
end
%
I   = abs(D1FitRez(uint32(I_types.I_cut),:));
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
ly 0 1
legend(plots,'Integral intensity','fit intensity');
%---------------------------------------------------------------
% Fit and plot spin-wave shape
valid = ~isnan(D1FitRez(uint32(I_types.gaus_sig),:));

qswm = D1FitRez(uint32(I_types.gaus_x0),valid);
qswm_err =D1FitRez(uint32(I_types.gaus_dx0),valid );

parab = @(x,par)(par(1)+(par(2)+par(3)*x).*x);
s.x = qswm;
s.y = e_sw(valid)';
s.e = qswm_err;
if numel(s.y) > 3
    [~,fit_par] = fit(s,parab,[1,1,1]);
else
    fit_par.p=[0,0,1100];
end
parR  = fit_par.p;

xxpf=max(min(qswm),-0.8)-0.02:0.01:min(max(qswm),0.8)+0.02;
yypf=parab(xxpf,parR);

cut_id = [caption(bragg),' Direction: ',caption(cut_direction)];
pl4=figure('Name',['Spin wave for: ', cut_id ]);
plot(xxpf,yypf,['-','g']);
hold on
ind    = find(valid);
qswm_err_l = ones(numel(valid),1)*NaN;
qswm_err_l(ind(:))= qswm_err(:);
errorbar(q_range,e_sw,qswm_err_l,'r');
errorbar(qswm,e_sw(valid),D1FitRez(uint32(I_types.gaus_sig),valid),'b');
lx(min(xxpf)-0.01,max(xxpf)+0.01);
ly(0,1.1*max(yypf));


fhhw_all  = D1FitRez(uint32(I_types.gaus_sig),valid);
ampl = D1FitRez(uint32(I_types.I_gaus_fit),valid);
ampl_avrg = sum(ampl)/sum(valid);
fwhh_avrg = sum(fhhw_all)/sum(valid);
deltaSq = sum((fhhw_all - fwhh_avrg).^2)/sum(valid);
deltaASq  = sum((ampl    - ampl_avrg).^2)/sum(valid);
fprintf('Av_amplitude: %f +-%f; Full height Half width average: %f +- %f\n',...
    ampl_avrg,sqrt(deltaASq),fwhh_avrg,sqrt(deltaSq));
drawnow
pause(1)
% remove non-converging workspaces
ws_valid =  ws_valid & ~isnan(sum(D1FitRez,1)');
%
D1Real = D1FitRez(bg1:bg2,ws_valid);

% S(Q,w) model
ff = 1; % 1
T = 8;  % 2
gamma = 10; % 3
Seff = 2;   % 4
gap = 0;    % 5

%J1 = 11.5625;    % 6
%J2 = 40.9508;
%J3 = 3.7300;
%J4 = -4.8408;
%J5 = 1.6475;
J1 = 25.29;
J2 = 13.930 ;
J3 =  -3.01;
J4  = 0;
J5 = 0;

par = [ff, T, gamma, Seff, gap, J1, J2, J3, J4,J5];

%
cut_list = cut_list(ws_valid);
kk = tobyfit2(cut_list);
%ff_calc = mff.getFF_calculator(cut_list(1));
kk = kk.set_local_foreground(true);
kk = kk.set_fun(@sqw_iron,par,[0,0,1,1,0,0,0,0,0,0]);
%kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,ff_calc,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg],[1,1,1,1,1]);
%kk = kk.set_bind({1,[1,2],1},{2,[2,2],1},{3,[3,2],1});
if numel(cut_list) > 1
    kk = kk.set_bind({6,[6,2],1},{7,[7,2],1},{8,[8,2],1});
end

% set up its own initial background value for each background function
bpin = arrayfun(@(i)(D1Real(:,i)'),1:size(D1Real,2),'UniformOutput',false);
kk = kk.set_bfun(@lin_bg,bpin);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;60;1.e-6]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
[w1D_arr1_tf,fp_arr1]=kk.fit;
%profile off
%profile viewer
for i=1:numel(w1D_arr1_tf)
    acolor('k');
    plot(cut_list(i));
    acolor('r');
    pd(w1D_arr1_tf(i));
    pause(1)
end
%cut_energies = e_sw(valid);
res_file = rez_name(data_source,bragg,cut_direction);
es_valid = arrayfun(@(x)(0.5*(x.data.iint(1,3)+x.data.iint(2,3))),cut_list);
save(res_file,'es_valid','data_source','bragg','cut_direction','dE','dK',...
    'cut_list','w1D_arr1_tf','fp_arr1');

if iscell(fp_arr1.p)
    fitpar = reshape([fp_arr1.p{:}],10,numel(fp_arr1.p))';
    fiterr = reshape([fp_arr1.sig{:}],10,numel(fp_arr1.sig))';
else
    fitpar = fp_arr1.p;
    fiterr = fp_arr1.sig;
end
disp('fitpar:')
disp(fitpar(:,3:10));
disp('fit_err:')
disp(fiterr(:,3:10));

%fback = kk.simulate(w110arr1_tf,'back');
%pl(fback)
Amp    = fitpar(:,4);
Amp_err= fiterr(:,4);
fhhw   = fitpar(:,3);
fhhw_err=fiterr(:,3);
ind    = find(ws_valid);
Amp_pl = ones(numel(ws_valid),1)*NaN;
Amp_pl_err = Amp_pl;
fhhw_pl    = Amp_pl;
fhhw_err_pl= Amp_pl;

Amp_pl(ind(:)) = Amp(:);
Amp_pl_err(ind(:)) = Amp_err(:);


pl01=figure('Name',['Tobyfitted SW intensity along dE; peak: ',caption(bragg),' Direction: ',caption(cut_direction)]);
errorbar(e_sw,Amp_pl,Amp_pl_err,'r');
%
ly 0 2
%legend(li2,'Tobifitted intensity','Tobyfit2 intensity')

xxpf=max(min(qswm),-0.8):0.01:min(max(qswm),0.8);
%par_sw = [0,0,4*pi*pi*fitpar(1,6)]; %if fitted with 3-component
%hamiltonian
par_sw = [0,0,4*pi*pi*26.];
yypf=parab(xxpf,par_sw);

pl5=figure('Name',['Tobyfitted spin wave dispersion for: ', cut_id ]);
plot(xxpf,yypf,['-','g']);
hold on
fhhw_pl(ind(:)) = fhhw(:);
fhhw_err_pl(ind(:))= fhhw_err(:);
q_sw_calc = inv_parab(e_sw,par_sw);
errorbar(q_sw_calc,e_sw,fhhw_pl,'b');
lx(1.1*min(xxpf)-0.01,1.1*max(xxpf)+0.01);


pl6=figure('Name',['Tobyfitted FHHW along spin wave for: ', cut_id ]);
errorbar(e_sw,fhhw_pl,fhhw_err_pl,'b');
ly 0 80
%---------------------------------------------------------------
disp(['Cut: ',cut_id,' fitting param: ',num2str(par_sw)]);
disp(['Cut: ',cut_id,' J : ',num2str(fitpar(1,6)),' Sig: ',num2str(fiterr(1,6))]);
result.sw_par = par_sw;
result.fit_par = fp_arr1;
result.ampl_vs_e = [e_sw,Amp_pl,Amp_pl_err];
result.fhhw_vs_e = [e_sw,fhhw_pl,fhhw_err_pl];
result.fhhw_along_sw = [q_sw_calc,e_sw,fhhw_pl];
result.fitted_sw = [xxpf,yypf];
result.eval_sw  = [q_sw_calc,e_sw,fhhw_pl];
result.esw_valid = es_valid;

% % recorrect intensity according to the new parabola params and plot it
% Icr = Iaf.*(2*D*abs(qswm));
% dIcr= dIaf.*(2*D*abs(qswm));
% pl5=figure('Name',['Corrected SW intensity along dE; peak: ',caption(bragg),' Direction: ',caption(cut_direction)]);
% ple=errorbar(e_sw,Icr,dIcr,'g');
% %
% ly 50 300
% legend(ple,['SW Intensity, dE: ',num2str(2*dE),' dk: ',num2str(2*dK)]);
%
all_plots = [pl1,pl2,pl3,pl4,pl5,pl6,pl01];
%
function q = inv_parab(en,par_coeff)
% Caclulate q-values using known energy values and parabolic spin-wave
% dispersion coefficients

split_point = find(isnan(en),1);
ind = 1:numel(en);

sign = ones(size(en));
if ~isempty(split_point)
    sign(ind<=split_point) = -1;
end

D2     = par_coeff(3);
Alpha  = par_coeff(2);
E0     = par_coeff(1);
q = sign.*sqrt((en+(0.25*Alpha*Alpha/D2-E0))/D2)- Alpha/(2*D2);


%

function y = TwoGaussAndBkgd(x, p, varargin)

y=(exp(-0.5*((x-p(2))/p(3)).^2)+exp(-0.5*((x+p(2))/p(3)).^2))*(p(1)/sqrt(2*pi)/p(3)) + (p(4)+x*p(5));


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


