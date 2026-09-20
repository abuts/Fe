function weight = dsho_fun_q(qh,qk,ql,en,par,hkl_proj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
persistent ff_calc;


ff_correct = par(1)==1;
enAv  = par(2);
gamma = par(3);
A = par(4);
peak_pos = par(6);

% Dispersion and spectral weight(=Seff/2)
%[wdisp,idisp] = disp_bcc_hfm(qh,qk,ql,par(4:end));
q = hkl_proj(1).transform_hkl_to_img([qh,qk,ql]');
q2 = (q(1,:).^2+q(2,:).^2+q(3,:).^2)';
q = sqrt(q2);

eg = en(:)/(gamma);
egAv = sum(eg)/numel(eg);
qe0g = enAv*peak_pos*q(:)/gamma;
Norm = (4*A*enAv*peak_pos/gamma)./(pi/2+atan(0.5*egAv));


%qq = omg0Sq*sqrt(q(1,:).^2+q(2,:).^2+q(3,:).^2)';


weight = Norm.*qe0g.*eg./(((eg-qe0g).*(eg+qe0g)).^2+4*eg.^2);
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