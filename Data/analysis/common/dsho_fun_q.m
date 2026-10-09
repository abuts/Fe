function weight = dsho_fun_q(qh,qk,ql,en,par,hkl_proj)
%pseudo-dispersion to evaluate shape and position of peaks
%
% 
persistent ff_calc;

ff_correct = par(1)==1;
%enAv  = par(2); % T in standard dispersion
gamma = abs(par(3));
A = abs(par(4));
stiff = abs(par(6));
% position of dispersion zone top in hkl
scale = 0.5; % |[1/2,1/2,0]| is the end of GN; |1/2,1/2,1/2| -- top of GP; 1 -- top of GH
% Dispersion and spectral weight(=Seff/2)
%[wdisp,idisp] = disp_bcc_hfm(qh,qk,ql,par(4:end));
qhkl = [qh,qk,ql]';
% convert to first brilluoin zone to deal with symmetry expansion. Cos
% should do that but not-obvious
bragg_pts = round(qhkl);
non_bragg = rem(sum(bragg_pts,1),2)~=0;
% fix parity
if any(non_bragg)
    %
    dist = abs(qhkl(:, non_bragg) - bragg_pts(:,non_bragg));
    [~,idx] = min(1-2*dist,[],1);
    nbrg_idx = find(non_bragg);
    for j=1:numel(nbrg_idx)
        ridx = nbrg_idx(j);
        cidx = idx(j);
        if qhkl(cidx,ridx)> bragg_pts(cidx,ridx)
            bragg_pts(cidx,ridx) = bragg_pts(cidx,ridx)+1;
        else
            bragg_pts(cidx,ridx) = bragg_pts(cidx,ridx)-1;            
        end
    end
end
qhklbr = qhkl-bragg_pts;

% Fold reciprocal-lattice points into the first Brillouin zone.
q = sqrt(sum(qhklbr.^2, 1));

eg = en(:)/(gamma);
enAv = sum(eg)/numel(eg);
qe0g = ((enAv/gamma)*stiff*(1-cos(0.5*pi/scale*q(:))));
Norm = (2*pi*A*enAv*stiff/gamma)./(pi/2+atan(0.5*eg));


%qq = omg0Sq*sqrt(q(1,:).^2+q(2,:).^2+q(3,:).^2)';


weight = Norm.*qe0g.*abs(sin((0.5*pi/scale)*q(:))).*eg./(((eg-qe0g).*(eg+qe0g)).^2+4*eg.^2);
%y = ((4/pi)*abs(gam.*en0))./((en.^2-en0.^2).^2 + 4*(gam.*en).^2);
if ff_correct
    if isempty(ff_calc)
        mag_ff = MagneticIons('Fe0');
        ff_calc = mag_ff.get_fomFactor_fh();
    end
    q = hkl_proj(1).transform_hkl_to_pix(qhkl);
    Q2 = (q(1,:).^2+q(2,:).^2+q(3,:).^2)'/(16*pi*pi);
    %mff = ff_calc{1}(Q2).^2+ff_calc{2}(Q2).^2+ff_calc{3}(Q2).^2; % ff_calc{4} == 0
    mff = ff_calc{1}(Q2).^2; % ff_calc{4} == 0
    weight = weight .* mff(:);    
end

end