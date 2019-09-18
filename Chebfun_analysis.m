function Chebfun_analysis(qh0,qk0,e0,id)

jn=@(N)(1:N);
Xn =@(N)(0.5-0.5*cos((jn(N)-0.5)*pi/N));
dp = fileparts(which('disp_dft_parameterized.m'));

persistent in_dat
if nargin > 3
    in_dat = id;
end

e_max = 680;
q0 = 1;
qi = (0:q0/100:q0)';
ei = (0:e_max/500:e_max)';

if isempty(in_dat)
    disp('***** loading reference data --->')
    in_dat = load(fullfile(dp,'Volume.mat'));
    disp('***** <--------- completed')
end
plot(qi,TN(qi,10));

ind_q = @(q0)find(q0<qi,1);
ind_e = @(e0)find(e0<ei,1);
fhk_int = @(h,k,e0)squeeze(in_dat.dat(ind_q(h),ind_q(k),:,ind_e(e0)));

if ~exist('qh0','var')
    qh0 = 0.9;
    qk0 = 0.8;
    e0 = 400;
end
in_line =  fhk_int(qh0,qk0,e0);
%in_line  = ones(size(in_line));


Nip = 21;
Mip = Nip-1;
Xj = Xn(Nip);
Ci = zeros(Mip,1);
for i=1:Mip
    Ci(i) = sum(lin_interp(qi,in_line,Xj).*TN(Xj,i)')/sum(TN(Xj,i).*TN(Xj,i));
end
C0 = sum(lin_interp(qi,in_line,Xj))/Nip;

plot(qi,in_line);
hold on
plot(qi,fhk_interp(qi',Mip,Ci,C0));
hold off
function r = TN(x,N)
r = cos(N.*acos(2*x-1)');


function rez = lin_interp(qi,inputs,q)
rez = interp1(qi,inputs,q);

function rez = fhk_interp(q,Mip,Ci,C0)

jn = 1:Mip;
tn = TN(q,jn);
rez = sum(tn.*Ci',2)+C0;