function weight = dsho_fun_q(qh,qk,ql,en,par,hkl_proj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
persistent ff_calc;
persistent uoffset;

ff_correct = par(1)==1;
enAv  = par(2);
gamma = abs(par(3));
A = abs(par(4));
stiff = abs(par(6));

% Dispersion and spectral weight(=Seff/2)
%[wdisp,idisp] = disp_bcc_hfm(qh,qk,ql,par(4:end));
q = hkl_proj(1).transform_hkl_to_pix([qh,qk,ql]');
if isempty(uoffset)
    off = hkl_proj(1).bmatrix(3)*hkl_proj(1).offset(1:3)';
    uoffset = sqrt(off(1)^2+off(2)^2+off(3)^2);
end

q2 = (q(1,:).^2+q(2,:).^2+q(3,:).^2)';
q = sqrt(q2);
q(:) = q(:)-uoffset;

eg = en(:)/(gamma);
%egAv = sum(eg)/numel(eg);
qe0g = (enAv/gamma)*q(:).^2*stiff;
Norm = (8*A*enAv*stiff/gamma)./(pi/2+atan(0.5*eg));


%qq = omg0Sq*sqrt(q(1,:).^2+q(2,:).^2+q(3,:).^2)';


weight = Norm.*qe0g.*abs(q).*eg./(((eg-qe0g).*(eg+qe0g)).^2+4*eg.^2);
%y = ((4/pi)*abs(gam.*en0))./((en.^2-en0.^2).^2 + 4*(gam.*en).^2);
if ff_correct
    if isempty(ff_calc)
        mag_ff = MagneticIons('Fe0');
        ff_calc = mag_ff.get_fomFactor_fh();
    end
    Q2 = q2/(16*pi*pi);
    %mff = ff_calc{1}(Q2).^2+ff_calc{2}(Q2).^2+ff_calc{3}(Q2).^2; % ff_calc{4} == 0
    mff = ff_calc{1}(Q2).^2; % ff_calc{4} == 0
    weight = weight .* mff(:);    
end

end