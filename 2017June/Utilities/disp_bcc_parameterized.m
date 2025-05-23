function [wdisp,sf] = disp_bcc_parameterized(qh,qk,ql,par)
% Spin wave dispersion relation for body centred cubic Heisenberg ferromagnet
%
%   >> [wdisp,sf] = disp_bcc_hfm (qh qk, ql, par)
%
% Input:
% ------
%   qh,qk,ql    Arrays of h,k,l
%   par         Parameters [Seff, gap, JS_p5p5p5, JS_100, JS_110, JS_3p5p5p5, JS_111]
%                   Seff        Intensity scale factor
%                   gap         Gap at zone centre
%                   JS_p5p5p5   First neighbour exchange constant
%                   JS_100      Second neighbour exchange constant
%                   JS_110      Third neighbour exchange constant
%                   JS_3p5p5p5  Fourth neighbour exchange constant
%                   JS_111      Fifth neighbour exchange constant
%
%              Note: each pair of spins in the Hamiltonian appears only once
% Output:
% -------
%   wdisp       Array of energies for the dispersion
%   sf          Array of spectral weights
persistent param
if isempty(param)
    param = load('J_vs_q');
    param.q2_min = param.qi_min^2;
    param.q2_max = param.qi_max^2;
end

%Seff=par(1);
gap=par(2);
dir = par(3);
% JS_p5p5p5=par(3);
% JS_100=par(4);
% JS_110=par(5);
% JS_3p5p5p5=par(6);
% JS_111=par(7);

w=gap*ones(size(qh));

q2 = qh.*qh+qk.*qk+ql.*ql;
JS_p5p5p5 = var_j(q2,param,dir);
err = interp1(param.q_sq,param.EvsQ_err{dir},q2);
% Pre-compute some arrays used in more than one exchange pathway

cos1h = cos(pi*qh);
cos1k = cos(pi*qk);
cos1l = cos(pi*ql);

% Contributions to dispersion
%JS_p5p5p5 =
w = w + (8*JS_p5p5p5).*(1-cos1h.*cos1k.*cos1l);


wdisp{1} = w;
sf{1} = err;
%sf{1} = (Seff/2)*ones(size(w));

function j = var_j(q2,param,dir)

if dir == 1
    q_l = q2>param.q2_max;
    q_s = q2<param.q2_min;
else
    q_l = false(size(q2));
    q_s= false(size(q2));
end

j = interp1(param.q_sq,param.JvsQ{dir},q2);
j(q_l) = param.J_max;
j(q_s) = param.J_min;