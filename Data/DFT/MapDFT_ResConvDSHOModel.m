function [disp_q,disp_q0,J_ds,J_ds0]=MapDFT_ResConvDSHOModel()
Nq = 100;
iq = 1:Nq;
Ne = 40;
ie = 1:Ne;
q_min = 1;
q_max = 3;
e_min = 10;
e_max = 210;

data_root = fileparts(fileparts(mfilename('fullpath')));
ds = fullfile(data_root,'sqw','Fe_ei401.sqw');
proj = struct('u',[1,0,0],'v',[0,1,0]);
% w_guide = cut_sqw(ds,proj,[1,0.04,3],[-0.1,0.1],[-0.1,0.1],5);
% plot(w_guide);

sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);


dQ    = (q_max-q_min)/(Nq-1);
dE    = (e_max-e_min)/(Ne-1);
q  = q_min+(iq-1)*dQ;
e  = e_min+(ie-1)*dE;

qh = q';
qk = -ones(size(qh));
ql = zeros(size(qh));
en = ones(size(qh));

S0_ampl    = zeros(Ne,1)*NaN;
J00_vsE    = zeros(Ne,1)*NaN;
Gam0_vsE   = zeros(Ne,1)*NaN;

S_ampl    = zeros(Ne,1)*NaN;
J0_vsE    = zeros(Ne,1)*NaN;
Gam_vsE   = zeros(Ne,1)*NaN;

S_ampl_exp    = zeros(Ne,1)*NaN;
J0_vsE_exp    = zeros(Ne,1)*NaN;
Gam_vsE   = zeros(Ne,1)*NaN;

bg     = zeros(Ne,2)*NaN;


J0=0.65;
Gamma = 0.3;
S = 1.3;
kB=8.6173324e-2;
T = 8;



const = 0;
grad = 0;
par0= [0,J0,Gamma,S,const,grad];

par= [J0,Gamma,S];
for i=1:Ne
    w_guide = cut_sqw(ds,proj,[1,0.04,3],[-0.1,0.1],[-0.1,0.1],[e(i)-5,e(i)+5]);
    if isempty(fieldnames(w_guide.header{1}.instrument))
        w_guide = set_sample_and_inst(w_guide,sample,@maps_instrument_for_tests,'-efix',600,'S');
    end
    Ei = en*e(i);
    fw = disp_dft_parameterized(qh,qk,ql,Ei,[1,0]);
    w1f = IX_dataset_1d(qh-0.5*(q_max+q_min),fw,ones(size(qh)));
    
    % Create "Experimental" resolution convoluted data.
    tfs = tobyfit2(w_guide);
    tfs = tfs.set_fun(@disp_dft_parameterized,[1,0],[1,0]);
    tfs  = tfs.set_mc_points(10);
    tfs  = tfs.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
    
    source = tfs.simulate;
    source.data.e = ones(size(source.data.e));
    %plot(qh,fw);
    %Int(i) = sum(fw);
    try
        
        par0(1) = e(i);
        [em,im] = max(fw);
        qm = qh(im)-0.5*(q_max+q_min);
        e2 = e(i)*e(i);
        e02 = e2/3*(1+2*sqrt(1+3*Gamma*Gamma/e2));
        e0 = sqrt(e02);
        par0(2) = sqrt(e02)/(1+cos(pi*qm))/8; %J0
        %par(3) = sqrt(par(2)*par(2)-1)*par(2)/3;  % gamma
        G2 = Gamma*Gamma;
        A_Fe = 8*kB*T*290.6/(3.*pi);
        par0(4) = (em/A_Fe)*((e2-e02)^2+4*G2*e2)/(Gamma*e0*e(i));  % S
        [w1_0tf,fp]=fit(w1f,@DSHO_nrf_hub,...
            par0,[0,1,1,1,1,1],'fit',[1.e-4,40,1.e-6]);
        
        par(1) = fp.p(2); %J0,
        par(2) = fp.p(3); % Gamma
        par(3) = fp.p(4);  %S
        %
        J00_vsE(i) = par(1);
        Gam0_vsE(i) = par(2);
        S0_ampl(i) = par(3);
        
        
        const = fp.p(4);
        grad = fp.p(5);
        tft = tobyfit2(source);
        tft = tft.set_fun(@DSHO_hub,par,[1,1,1]);
        tft = tft.set_bfun(@lin_bg,[const,grad]);
        
        tft = tft.set_mc_points(10);
        
        tft = tft.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
        
        [w1_tf,fp]=tft.fit;
        
    catch
        continue
    end
    acolor('k')
    plot(source)
    acolor('g')
    w1_0tf.x = w1_0tf.x+0.5*(q_max+q_min);
    pl(w1_0tf,'name','Horace 1D plot');
    acolor('r')
    pl(w1_tf);
    if  ~fp.converged
        continue
    end
    J0_vsE(i)  = fp.p(1);
    Gam_vsE(i) = abs(fp.p(2));
    S_ampl(i)  = fp.p(3);
    
    Gamma = Gam_vsE(i);  % gamma
    
    bg(i,:) = fp.bp(:);
    
end
disp_q = IX_dataset_1d(e,S_ampl,Gam_vsE*0.1);
disp_q.title = 'DSHO fit. S+-Gamma + linear background';
disp_q.x_axis = 'En (mEv)';
acolor('r')
plot(disp_q);
acolor('g')
disp_q0 = disp_q;
disp_q0.signal = S0_ampl;
disp_q0.error  = Gam0_vsE;
pd(disp_q0);

bg_d = IX_dataset_1d(e,bg(:,1));
bg_d.title = 'backgound';

acolor('k');
pl(bg_d);
keep_figure;

acolor('r')
J_ds = IX_dataset_1d(e,J0_vsE);
J_ds.x_axis = 'En (mEv)';
J_ds.s_axis = 'J0 (mEv)';
dl(J_ds);
J_ds0 = J_ds;
J_ds0.signal = J00_vsE;
acolor('g');
pl(J_ds0);
keep_figure;


function y = DSHO_hub(hh,hk,hl,en, p, varargin)

%  use ff,T,Gamma,S,gp,J0
par = [0,8,p(2),p(3),0,abs(p(1)),0,0,0,0];

y = sqw_iron(hh,hk,hl,en,par);


function bg = lin_bg(x,par)
%
bg  = par(1)+x*par(2);

function y = DSHO_nrf_hub(x, p, varargin)

%  use ff,T,Gamma,S,gp,J0
par = [0,8,p(3),p(4),0,abs(p(2)),0,0,0,0];

%y = sqw_iron (qh,qk,ql,en,par)
base = ones(size(x));
en   = base*p(1);
hl   = base*0;
hk   = base*(-1);
y = sqw_iron(x,hk,hl,en,par)+...
    (p(5)+x*p(6));
