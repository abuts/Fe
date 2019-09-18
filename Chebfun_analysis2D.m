function out_dat = Chebfun_analysis2D(qh0,e0,id)

jn=@(N)(1:N);
Xn =@(N)(0.5-0.5*cos((jn(N)-0.5)*pi/N));
dp = fileparts(which('disp_dft_parameterized.m'));



persistent in_dat
if nargin > 2
    in_dat = id;
end
out_dat = in_dat;

if ~exist('qh0','var')
    qh0 = 0.9;
    e0 = 400;
end

e_max = 680;
q0 = 1;
qi = (0:q0/100:q0)';
ei = (0:e_max/500:e_max)';
[qix,qiy] = meshgrid(qi,qi);


if isempty(in_dat)
    disp('***** loading reference data --->')
    in_dat = load(fullfile(dp,'Volume.mat'));
    disp('***** <--------- completed')
end
plot(qi,TN(qi,10));

ind_q = @(q0)find(q0<qi,1);
ind_e = @(e0)find(e0<ei,1);
fhk_int = @(h,e0)squeeze(in_dat.dat(ind_q(h),:,:,ind_e(e0)));

in_line =  fhk_int(qh0,e0);
%in_line = repmat(in_line(1,:),size(in_line,1),1);
surf(qix,qiy,in_line,'EdgeColor','none');
%hold on

Nip = 81;
Xj = Xn(Nip);
Ci = zeros(Nip,Nip);
ip_array = lin_interp(qi,in_line,Xj);
for j=1:Nip
    j0 = j-1;
    Tj = TN(Xj,j0);
    Norm_j = Tj'*Tj;
    for i=1:Nip
        i0 = i-1;
        Ti = TN(Xj,i0);
        Norm_i = Ti'*Ti;
        T_mat = Tj'.*Ti/(Norm_i*Norm_j);
        pcs = ip_array.*T_mat;                        

        Ci(i,j) = sum(sum(pcs));
    end
end


sip = fhk_interp(qi,Nip,Ci');
figure
surf(qix,qiy,sip,'EdgeColor','none');
%hold off
function r = TN(x,N)
r = cos(N.*acos(2*x-1)');


function rez = lin_interp(qi,inputs,qr)
[qix,qiy] = meshgrid(qi,qi);
[qx,qy] = meshgrid(qr,qr);
rez = interp2(qix,qiy,inputs,qx,qy);

function rez = fhk_interp(q,Nip,Ci)

nq = numel(q);
jn = 0:Nip-1;
tn = TN(q',jn);
%rez = tn*Ci*tn'+C0;
rez = zeros(nq);
for j=1:nq
    for i=1:nq
        Tm = tn(i,:).*tn(j,:)';
        rez(i,j) = sum(sum( Ci.*Tm));
    end
end