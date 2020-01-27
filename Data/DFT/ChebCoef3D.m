function Cijk = ChebCoef3D(signal4D)

jn=@(N)(1:N);
Xn =@(N)(0.5-0.5*cos((jn(N)-0.5)*pi/N));

Nip = size(signal4D,1);
Cijk = zeros(size(signal4D));
Xj = Xn(Nip);
for nE = 1:size(signal4D,4)
    ip_array = squeeze(signal4D(:,:,:,nE));
    exclude = isnan(ip_array);
    ip_array(exclude) = 0;
    for k=1:Nip
        k0 = k-1;
        Tk = TN(Xj,k0);
        Norm_k = Tk'*Tk;
        for j=1:Nip
            j0 = j-1;
            Tj = TN(Xj,j0);
            Norm_j = Tj'*Tj;
            for i=1:Nip
                i0 = i-1;
                Ti = TN(Xj,i0);
                Norm_i = Ti'*Ti;
                T_mat = repmat((Tj'.*Ti)',1,1,Nip).*...
                    permute(repmat(Tk,1,Nip,Nip),[3,2,1])/(Norm_i*Norm_j*Norm_k);
                pcs = ip_array.*T_mat;
                
                Cijk(i,j,k) = sum(sum(sum(pcs)));
            end
        end
    end
end

function r = TN(x,N)
r = cos(N.*acos(2*x-1)');
