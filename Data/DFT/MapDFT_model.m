
Nq = 100;
iq = 1:Nq;
Ne = 50;
ie = 1:Ne;
q_min = 0;
q_max = 2;
e_min = 0;
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

Int = zeros(Ne,1);
for i=1:Ne
    Ei = en*e(i);
    fw = disp_dft_parameterized(qh,qk,ql,Ei,par{:});
    %plot(qh,fw);
    Int(i) = sum(fw);
end
plot(e,Int);
