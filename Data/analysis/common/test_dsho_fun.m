function weight = test_dsho_fun(q,en,par,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
enAv  = par(2);
gamma = par(3);
A = par(4);
peak_pos = par(6);

% Dispersion and spectral weight(=Seff/2)
%[wdisp,idisp] = disp_bcc_hfm(qh,qk,ql,par(4:end));
%enAv  = sum(en(:))/numel(en);
omg0 = enAv;

%omg0Sq = omg0*omg0;
qomg = omg0*q(:)*peak_pos;
if any(gamma*1.001>qomg)
    gamma = min(qomg)/1.001;
end

gamSq = gamma*gamma;
eg = qomg/gamma;
egSq = eg.*eg;
%Norm = (4/pi)*A*gamma*sqrt(omg0Sq-gamSq);
Gr = sqrt((eg - 1).*(eg+1));
Norm = 0.25*(eg./Gr).*(pi/2-atan((1-0.5*egSq)./Gr));
%Norm = (8/pi)*A*gamma*omg0/enAv;

%q = hkl_proj(1).transform_hkl_to_img([qh,qk,ql]');
%qq = omg0Sq*sqrt(q(1,:).^2+q(2,:).^2+q(3,:).^2)';


% sho shape
en = en(:);
weight = (A*gamma./Norm).*qomg.*en./(((en-qomg).*(en+qomg)).^2+(4*gamSq)*en.^2);
%y = ((4/pi)*abs(gam.*en0))./((en.^2-en0.^2).^2 + 4*(gam.*en).^2);

end