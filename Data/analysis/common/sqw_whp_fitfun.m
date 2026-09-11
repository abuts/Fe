function weight = sqw_whp_fitfun(qh,qk,ql,en,par,hkl_proj)
% 
%   >> weight = sqw_iron (qh,qk,ql,en,par,proj)
%
% Input:
% ------
%   qh,qk,ql    Arrays of h,k,l. 
%               The values must belong to first Brilluoin zone, so the cuts
%               should be offset appropriately !!!
% 
%   par         Parameters [ff, e0, gamma, A, gap, peak_pos]
%                   ff          =1 if form factor multiplication to be applied
%                               =0 if no form factor multiplication to be applied
%                   e0           Temperature (K)
%                   gamma       Inverse lifetime (meV)
%                   Seff        Intensity scale factor: effective spin per ion
%                   gap         Gap at zone centre
%
%
%              Note: each pair of spins in the Hamiltonian appears only once
%
%
% Output:
% -------
%   weight      

persistent ff_calc;

if par(1)==1
    ff_correct = true;
elseif par(1)==0
    ff_correct = false;
else
    error('Parameter ff must be 0 or 1')
end
%T = par(2);
%gamma = par(3);
%Seff = par(4);
%gap = par(5);
%JS = par(6:end);
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

q = hkl_proj(1).transform_hkl_to_img([qh,qk,ql]');
qq = omg0Sq*sqrt(q(1,:).^2+q(2,:).^2+q(3,:).^2)';
qqSq = qq.^2;
% sho shape
weight = Norm*en./((en.^2-qqSq).^2+(4*gamSq)*en.^2);

% Correct for magnetic form factor if requested
if ff_correct
    if isempty(ff_calc)
        mag_ff = MagneticIons('Fe0');
        ff_calc = mag_ff.get_fomFactor_fh();
    end
    q_coord = hkl_proj(1).transform_hkl_to_pix([qh,qk,ql]');
    Q2 = (q_coord(1,:).^2+q_coord(2,:).^2+q_coord(3,:).^2)/(16*pi*pi);
    %mff = ff_calc{1}(Q2).^2+ff_calc{2}(Q2).^2+ff_calc{3}(Q2).^2; % ff_calc{4} == 0
    mff = ff_calc{1}(Q2).^2; % ff_calc{4} == 0
    weight = weight .* mff(:);

end

