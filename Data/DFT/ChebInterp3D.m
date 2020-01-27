function Si = ChebInterp3D(Cn,qx,qy,qz)

jn=@(N)(1:N);
Nip = size(Cn,1);
jj  = jn(Nip);
tx = TN(qx',jj);
ty = TN(qy',jj);
tz = TN(qz',jj);
Si = zeros(numel(qx),1);
for i=1:numel(qx)
    Tm = repmat(tx(i,:).*ty(i,:)',1,1,Nip).*...
         permute(repmat(tz(i,:)',1,Nip,Nip),[3,2,1]);
    Si(i) = sum(sum(sum(Cn.*Tm)));
end
function r = TN(x,N)
r = cos(N.*acos(2*x-1)');
