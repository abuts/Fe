function weight = test_dsho_fun_q(q,en,par,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
enAv  = par(2);
gamma = par(3);
A = par(4);
peak_pos = par(6);

% Dispersion and spectral weight(=Seff/2)
%[wdisp,idisp] = disp_bcc_hfm(qh,qk,ql,par(4:end));

eg = en(:)/(gamma);
qe0g = enAv*(q(:)+1-peak_pos)/gamma;
Norm = (4*A*enAv/gamma)./(pi/2+atan(0.5*eg));

%q = hkl_proj(1).transform_hkl_to_img([qh,qk,ql]');
%qq = omg0Sq*sqrt(q(1,:).^2+q(2,:).^2+q(3,:).^2)';


weight = Norm.*abs(qe0g).*eg./(((eg-qe0g).*(eg+qe0g)).^2+4*eg.^2);
%y = ((4/pi)*abs(gam.*en0))./((en.^2-en0.^2).^2 + 4*(gam.*en).^2);

end