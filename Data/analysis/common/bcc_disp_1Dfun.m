function weight = bcc_disp_1Dfun(x,par,hkl_proj)
% Dispersion for domain averaged body centred cubic Heisenberg ferromagnet
%
%   >> weight = bcc_disp_1Dfun(x,en,par,ion)
%
% Input:
% ------
%   x           coordinates of the function along x-axis (u-vector of projection)
%   par         Parameters [ff, T, gamma, Seff, gap, JS_p5p5p5, JS_100,...
%                                               JS_110, JS_3p5p5p5, JS_111]
%                   ff          =1 if form factor multiplication to be applied
%                               =0 if no form factor multiplication to be applied
%                   T           Temperature (K)
%                   gamma       Inverse lifetime (meV)
%                   Seff        Intensity scale factor: effective spin per ion
%                   gap         Gap at zone centre
%                   JS_p5p5p5   First neighbour exchange constant
%                   JS_100      Second neighbour exchange constant
%                   JS_110      Third neighbour exchange constant
%                   JS_3p5p5p5  Fourth neighbour exchange constant
%                   JS_111      Fifth neighbour exchange constant
%
%              Note: each pair of spins in the Hamiltonian appears only once
%
%   ion         Object of class MagneticIon from which the magnetic form factor
%              is calculated e.g. ion = MagneticIon('Fe0')
%               If empty or not given, no form factor correction is performed.
%

%persistent ff_calc;

if par(1)==1
    ff_correct = true;
elseif par(1)==0
    ff_correct = false;
else
    error('Parameter ff must be 0 or 1')
end
T = par(2);
gamma = par(3);

u = hkl_proj(1).u;
hkl = u(:)*x'+hkl_proj(1).offset(1:3)';

% Dispersion and spectral weight(=Seff/2)
%[wdisp,idisp] = disp_bcc_hfm(qh,qk,ql,par(4:end));
[wdisp,idisp] = disp_bcc_hfm(hkl(1,:),hkl(2,:),hkl(3,:),par(4:6));
weight  = wdisp{1}.*idisp{1};

% % Broaden by damped simple harmonic oscillator, preserving static susceptibility
% weight = (((4/3)*290.6)*idisp{1}) .* (dsho_over_eps (en, wdisp{1}, gamma) .* bose_times_eps(en,T));
% 
% % Correct for magnetic form factor if requested
% if ff_correct
%     if isempty(ff_calc)
%         mag_ff = MagneticIons('Fe0');
%         ff_calc = mag_ff.get_fomFactor_fh();
%     end
%     q_coord = hkl_proj(1).transform_hkl_to_pix([qh,qk,ql]');
%     Q2 = (q_coord(1,:).^2+q_coord(2,:).^2+q_coord(3,:).^2)/(16*pi*pi);
%     mff = ff_calc{1}(Q2).^2+ff_calc{2}(Q2).^2+ff_calc{3}(Q2).^2; % ff_calc{4} == 0
%     weight = weight .* mff(:);
% 
% end

