function weight = iron_phonons(qh,qk,ql,en,par,initial_sqw)
% Spectral weight for domain averaged body centred cubic Heisenberg ferromagnet
%
%   >> weight = sqw_iron (qh,qk,ql,en,par,ion)
%
% Input:
% ------
%   qh,qk,ql    Arrays of h,k,l
%   par         Parameters

Am     = par(1);
gamma1 = par(2);
gamma2 = par(3);


% Dispersion and spectral weight(=Seff/2)
omega = dynamical_bcc_5nn(qh,qk,ql,par(4:end));

% Broaden by damped simple harmonic oscillator, preserving static susceptibility
weight = Am * (dsho_over_eps (en, omega(1,:)', gamma1)+...
    dsho_over_eps (en, omega(2,:)', gamma2) + ...
    dsho_over_eps (en, omega(3,:)', gamma2) );

%fe_par = [];
%wght2 = sqw_iron(qh,qk,ql,en,fe_par,initial_sqw);
%weight = weight+whght2;
