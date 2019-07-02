function FitKUN_DSHOModel5J()
% fit Kun sumulations using 5 coordination spheres J model
%

alatt = [2.84,2.84,2.84];
angdeg = [90,90,90];
u=[1,0,0];
v = [0,1,0];
psi = 0;

fcc = FCC_Igrid();

sym_list = [1,2,3,4,5];
dir_list = [1,1,1,1,1];
%sqw_obj = repmat(sqw(),1,numel(sym_list));
Ei = 805;
for i=1:numel(sym_list)
    [q_range,e_range,dir,start] = fcc.get_range(sym_list(i),dir_list(i));
    [v,u,~,Ld] = build_ort(dir);
    
    sqqw =fake_sqw(e_range,q_range,'',Ei,1, alatt, angdeg,...
        u, v, psi, 0, 0, 0, 0,[10,1,1,10]);
    sqqw  = sqqw{1};

    pix_base = sqqw.data.pix(1:4,:);
    u_to_rlu = sqqw.data.u_to_rlu(1:3,1:3);
    [~,ind] = sort(pix_base(4,:));
    pix_base  = pix_base(:,ind);
    
    quu =inv(u_to_rlu)\q_range';
    n_en = numel(e_range);
    for j=1:n_en-1
        pix_base(1:3,n_en*(j-1)+1:n_en*(j))= quu;
    end
    sqqw.data.pix(1:4,:) = pix_base;    
    sqqw = sqw_eval(sqqw,@disp_kun_calc,[1,0,sym_list(i),dir_list(i)]);
    %sqqw  = cut_sqw(sqqw,[],[],[],[]);    
    

    proj = struct('u',u,'v',v);
    sqqw  = cut_sqw(sqqw,proj,[-0.01,0.01,Ld+0.01],[-0.1,0.1],[-0.1,0.1],[0,8,805]);
    
    %sqqw = cut(sqqw,[],[],[],[]);
    
    
    
    if i==1
        sqw_obj = repmat(sqqw,1,numel(sym_list));
    else
        sqw_obj(i) = sqqw;
    end
    plot(sqw_obj(i));
end




%data_dir = fileparts(fileparts(mfilename('fullpath')));
%par_file = fullfile(data_dir,'sources','SPE_EI401','map15052_ei400meV.nxspe');

qh = q';
qk = -ones(size(qh));
ql = zeros(size(qh));
en = ones(size(qh));

S_ampl    = zeros(3,Ne)*NaN;
J0_vsE    = zeros(3,Ne)*NaN;
Gam_vsE   = zeros(3,Ne)*NaN;
bg     = zeros(Ne,2)*NaN;


J0=0.65;
Gamma = 0.3;
S = 1.3;
kB=8.6173324e-2;
T = 8;

% J0=2.5;
% Gamma = 2.5;
% S = 1;

const = 0;
grad = 0;
par= [0,J0,Gamma,S,const,grad];
for i=1:Ne
    Ei = en*e(i);
    fw = disp_kun_calc(qh,qk,ql,Ei,[1,0,1,4]);
    w1f = IX_dataset_1d(qh-1,fw,ones(size(qh)));
    %plot(qh,fw);
    %Int(i) = sum(fw);
    try
        par(1) = e(i);
        [em,im] = max(fw);
        qm = qh(im)-1;
        e2 = e(i)*e(i);
        e02 = e2/3*(1+2*sqrt(1+3*Gamma*Gamma/e2));
        e0 = sqrt(e02);
        par(2) = sqrt(e02)/(1+cos(pi*qm))/8; %J0
        %par(3) = sqrt(par(2)*par(2)-1)*par(2)/3;  % gamma
        G2 = Gamma*Gamma;
        A_Fe = 8*kB*T*290.6/(3.*pi);
        par(4) = (em/A_Fe)*((e2-e02)^2+4*G2*e2)/(Gamma*e0*e(i));  % S
        [w1_tf,fp]=fit(w1f,@DSHO_hub,...
            par,[0,1,1,1,1,1],'fit',[1.e-4,40,1.e-6]);
        %[w1_tf,fp]=fit(w1f,@DSHO_hub,...
        %    par,[0,1,1,1,1,1],'evaluate');
        S_ampl(1,i) = e(i);
        J0_vsE(1,i) = e(i);
        Gam_vsE(1,i) = e(i);
        
    catch
        continue
    end
    acolor('k')
    plot(w1f)
    acolor('r')
    pl(w1_tf);
    if  ~fp.converged
        continue
    end
    J0_vsE(2,i) = fp.p(2);
    Gam_vsE(2,i) = abs(fp.p(3));
    S_ampl(2,i) = fp.p(4);
    
    J0_vsE(3,i) = fp.sig(2);
    Gam_vsE(3,i) = fp.sig(3);
    S_ampl(3,i) = fp.sig(4);
    
    
    
    Gamma = Gam_vsE(2,i);  % gamma
    
    bg(i,:) = fp.p(5:6);
    
end
disp_q = IX_dataset_1d(S_ampl);
disp_q.title = 'DSHO fit. S+ linear background';
disp_q.x_axis = 'En (mEv)';
acolor('g')
dd(disp_q);
bg_d = IX_dataset_1d(e,bg(:,1));
bg_d.title = 'backgound';

acolor('k');
pl(bg_d);
keep_figure;

disp_q = IX_dataset_1d(Gam_vsE);
disp_q.title = 'DSHO fit: Gamma';
disp_q.x_axis = 'En (mEv)';
acolor('r')
pd(disp_q);
keep_figure;


J_ds = IX_dataset_1d(J0_vsE);
J_ds.x_axis = 'En (mEv)';
J_ds.s_axis = 'J0 (mEv)';
pd(J_ds);
keep_figure;


function y = DSHO_hub(x, p, varargin)

%  use ff,T,Gamma,S,gp,J0
par = [0,8,p(3),p(4),0,abs(p(2)),0,0,0,0];

%y = sqw_iron (qh,qk,ql,en,par)
base = ones(size(x));
en   = base*p(1);
hl   = base*0;
hk   = base*(-1);
y = sqw_iron(x,hk,hl,en,par)+...
    (p(5)+x*p(6));
