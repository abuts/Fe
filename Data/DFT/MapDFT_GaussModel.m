function MapDFT_GaussModel()
Nq = 100;
iq = 1:Nq;
Ne = 50;
ie = 1:Ne;
q_min = 0;
q_max = 2;
e_min = 10;
e_max = 680;

dQ    = (q_max-q_min)/(Nq-1);
dE    = (e_max-e_min)/(Ne-1);
q  = q_min+(iq-1)*dQ;
e  = e_min+(ie-1)*dE;

qh = q';
qk = -ones(size(qh));
ql = zeros(size(qh));
en = ones(size(qh));
par = {1,0};

Int     = zeros(Ne,1);
q_vs_e  = zeros(Ne,1);
sigma   = zeros(Ne,1);
bg     = zeros(Ne,2);
IP = 10;
q_i = 0.1;
peak_width = 0.01;
const = 0;
grad = 0;
for i=1:Ne
    Ei = en*e(i);
    fw = disp_dft_parameterized(qh,qk,ql,Ei,par{:});
    w1f = IX_dataset_1d(qh-1,fw,ones(size(qh)));
    %plot(qh,fw);
    %Int(i) = sum(fw);
    try
        [w1_tf,fp]=fit(w1f,@TwoGaussAndBkgd,...
            [IP,q_i,peak_width,const,grad],[1,1,1,1,1],'fit',[1.e-4,40,1.e-6]);
    catch
        continue
    end
    acolor('k')
    plot(w1f)
    acolor('r')
    pl(w1_tf);
    Int(i) = fp.p(1);
    q_i    = fp.p(2);    
    q_vs_e(i) = q_i;
    q_i = q_vs_e(i);
    

    sigma(i) = fp.p(3);
    bg(i,:) = fp.p(4:5);
    
end
disp_q = IX_dataset_1d(e,q_vs_e,sigma);
disp_q.title = 'Double gaussian fit. Amplitude and decay + linear background*0.1';
disp_q.x_axis = 'En (mEv)';
acolor('r')
plot(disp_q);
bg_d = IX_dataset_1d(e,0.1*bg(:,1));
bg_d.title = 'backgound*0.1';

acolor('k');
pl(bg_d);


