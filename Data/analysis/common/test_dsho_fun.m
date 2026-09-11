function weight = test_dsho_fun(q,en,par,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
e0  = par(2);
gamma = par(3);
A = par(4);
peak_pos = par(6);

% Dispersion and spectral weight(=Seff/2)
%[wdisp,idisp] = disp_bcc_hfm(qh,qk,ql,par(4:end));
omg0 = e0*peak_pos;
omg0Sq = omg0*omg0;
gamSq = gamma*gamma;
Norm = (4/pi)*A*gamma*sqrt(omg0Sq-gamSq);

%q = hkl_proj(1).transform_hkl_to_img([qh,qk,ql]');
%qq = omg0Sq*sqrt(q(1,:).^2+q(2,:).^2+q(3,:).^2)';
qq = omg0Sq*q(:);
qqSq = qq.^2;
% sho shape
en = en(:);
weight = Norm*en./((en.^2-qqSq).^2+(4*gamSq)*en.^2);
%y = ((4/pi)*abs(gam.*en0))./((en.^2-en0.^2).^2 + 4*(gam.*en).^2);

end