function y = sw_and_phon_parab_disp(proj,ff_calc,qh,qk,ql,en,pars)

%JS = pars(3);
%D2 = 4*pi*pi*JS;
D2     = pars(3);
Alpha  = pars(2);
E0     = pars(1);
if(E0<0)
    E0 = -E0;
    handicap = true;
else
    handicap = false;
end
q0 = sqrt((en+(0.25*Alpha*Alpha/D2-E0))/D2);
dq  = Alpha/(2*D2);

if abs(proj.u(1))>0
    qhp2 = (qh - proj.uoffset(1)-(dq+q0)*proj.u(1)).^2;
    qhm2 = (qh - proj.uoffset(1)-(dq-q0)*proj.u(1)).^2;
    qh2 = min(qhp2,qhm2);
else
    qh2 = (qh - proj.uoffset(1)).^2;
end
if abs(proj.u(2))>0
    qkp2 = (qk - proj.uoffset(2)-(dq+q0)*proj.u(2)).^2;
    qkm2 = (qk - proj.uoffset(2)-(dq-q0)*proj.u(2)).^2;
    qk2 = min(qkp2,qkm2);
else
    qk2 = (qk - proj.uoffset(2)).^2;
end
if abs(proj.u(3))>0
    qlp2 = (ql - proj.uoffset(3)-(dq+q0)*proj.u(3)).^2;
    qlm2 = (ql - proj.uoffset(3)-(dq-q0)*proj.u(3)).^2;
    ql2 = min(qlp2,qlm2);
else
    ql2 = (ql - proj.uoffset(3)).^2;
end

x2 = (qh2+qk2+ql2);
mag_ff = ff_calc(qh,qk,ql,en,[]);

ampl = pars(4);
sig=pars(5)/sqrt(log(256));
y=exp(-x2/(2*sig*sig))*(ampl/sqrt(2*pi)/sig).*mag_ff';

if handicap
    y = y+E0*sum(y)*100;
end
