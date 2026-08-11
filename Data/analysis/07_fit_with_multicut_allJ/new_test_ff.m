function mff  = new_test_ff(qh,qk,ql,hkl_proj)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
persistent ff_calc;

if isempty(ff_calc)
    mag_ff = MagneticIons('Fe0');
    ff_calc = mag_ff.get_fomFactor_fh();
end
q_coord = hkl_proj(1).transform_hkl_to_pix([qh,qk,ql]');
Q2 = (q_coord(1,:).^2+q_coord(2,:).^2+q_coord(3,:).^2)/(16*pi*pi);
%old form factor was accounting for the first moment only
mff = ff_calc{1}(Q2).^2+ff_calc{2}(Q2).^2+ff_calc{3}(Q2).^2; % ff_calc{4} == 0
%weight = weight .* mff(:);
end