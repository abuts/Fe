function weight = sqw_iron (qh,qk,ql,en,par)
% Spectral weight for domain averaged body centred cubic Heisenberg ferromagnet
%
%   >> weight = sqw_iron (qh,qk,ql,en,par,ion)
%
% Input:
% ------
%   qh,qk,ql    Arrays of h,k,l
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
% Output:
% -------
%   weight      Spectral weight in units of mbarn/(steradian.meV.magnetic_ion)
%              and is given by:
%                   (gyro*r0)^2 * <1 + Qz^2> * (g*F(Q)/2)^2 * (Seff/2) *...
%                       (<n(en)+1>*delta(en-en(q)) + <n(en)>*delta(en+en(q)))
%
%              where
%                   (gyro*r0)^2 Constant: 290.6 mbarn
%                   Qz          Component of unit momentum transfer along
%                              the moment direction. For cubic symmetry,
%                              we have the domain averaged value <1+Qz^2> = 4/3
%                   g           Electron gyronagnetic ratio
%                   F(Q)        Magnetic form factor
%
%              and the delta functions are broadened by the response for
%              a damped simple harmonic oscillator with inverse lifetime gamma.
%
%               The connection to the neutron scattering cross-section is:
%                   d^2(sigma)/d(Omega)d(eps) = (ki/kf) * N * sqw_iron
%
%               where
%                   N   Number of magnetic ions
%                   ki  Initial wavevector
%                   kf  Final wavevector


if par(1)==1
    ff_correct = true;
elseif par(1)==0
    ff_correct = false;
else
    error('Parameter ff must be 0 or 1')
end
%T = par(2);
gamma = par(3);

% Dispersion and spectral weight(=Seff/2)
[wdisp,idisp] = disp_bcc_hfm (qh,qk,ql,par(4:end));

% Broaden by damped simple harmonic oscillator, preserving static susceptibility
weight = 2*idisp{1} .* TwoGauss (en, wdisp{1}, gamma);

% Correct for magnetic form factor if requested
if ff_correct
    ssqr = (((2*pi/2.87))^2/(16*pi^2))*(qh.^2 + qk.^2 + ql.^2);  % assumes iron lattice parameter = 2.87 Ang
    ffpar = [0.0706, 35.008, 0.3589, 15.358, 0.5819, 5.561, -0.0114, 0.1398];
    ffsqr = (ffpar(1)*exp(-ffpar(2)*ssqr)+ffpar(3)*exp(-ffpar(4)*ssqr)+ffpar(5)*exp(-ffpar(6)*ssqr)+ffpar(7)).^2;
    weight = weight .* ffsqr;
end

function y = TwoGauss(x, q0, gamma)

y=(exp(-0.5*((x-q0)/gamma).^2))/sqrt(2*pi)/gamma;

