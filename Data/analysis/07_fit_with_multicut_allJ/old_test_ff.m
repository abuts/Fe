function ffsqr = old_test_ff(qh,qk,ql)

    ssqr = (((2*pi/2.845))^2/(16*pi^2))*(qh.^2 + qk.^2 + ql.^2);  % assumes iron lattice parameter = 2.845 Ang
    ffpar = [0.0706, 35.008, 0.3589, 15.358, 0.5819, 5.561, -0.0114, 0.1398];
    ffsqr = (ffpar(1)*exp(-ffpar(2)*ssqr)+ffpar(3)*exp(-ffpar(4)*ssqr)+ffpar(5)*exp(-ffpar(6)*ssqr)+ffpar(7)).^2;
    %weight = weight .* ffsqr;
end