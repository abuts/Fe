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
if gamma*1.1>omg0
    gamma = omg0/1.1;
end
omg0Sq = omg0*omg0;
gamSq = gamma*gamma;
%Norm = (4/pi)*A*gamma*sqrt(omg0Sq-gamSq);
Gr = sqrt(omg0Sq/gamSq -1);
Norm = A*4*gamSq*Gr/omg0/(pi/2-atan2(1-0.5*omg0Sq/gamSq,Gr));
%Norm = (8/pi)*A*gamma*omg0/enAv;

%q = hkl_proj(1).transform_hkl_to_img([qh,qk,ql]');
%qq = omg0Sq*sqrt(q(1,:).^2+q(2,:).^2+q(3,:).^2)';
qomg = omg0*q(:)*peak_pos;

% sho shape
en = en(:);
weight = Norm*qomg.*en./(((en-qomg).*(en+qomg)).^2+(4*gamSq)*en.^2);
%y = ((4/pi)*abs(gam.*en0))./((en.^2-en0.^2).^2 + 4*(gam.*en).^2);

end