function plot_dispersion()
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];

lattice=[alatt,angdeg];
rlp=[0,0,0; 0,0,1; 0,0,0; 1,0,0; 0,0,0; 1,1,0; 0,0,0; 1,1,1]; 
pars=[1,0.05,0.05,35,-5,15,10,0.1];
ecent=[0,0.5,200];
fwhh=2;
%disp2sqw_plot(lattice,rlp,@sr122_disp,pars,ecent,fwhh);



rlp = [0,0,0; 0,0,1; 0,1/2,1/2; 0,0,0; 1/2,1/2,1/2; 1/2,1/2,0];
disp2sqw_plot(lattice,rlp,dispreln,pars,ebins,fwhh)
end

function [wdisp1,s_yy]=sr122_disp(qh,qk,ql,p)
%
% SrFe2As2 cross-section, from Tobyfit
%

%  Spin waves for FeAs, from Ewings et al., PRB 78 
%  Lattice parameters as for orthorhombic lattice i.e. a ~= b ~5.6Ang
% 
% 	p(1)	S_eff
% 	p(2)	SK_ab
% 	p(3)	SK_c
% 
%    If ircoss=201:
% 	p(4)	SJ_1a
% 	p(5)	SJ_1b
% 	p(6)	SJ_2
% 
%    If icross=202
% 	p(4)	S(2J2+J_1a)
% 	p(5)	S(2J2-J_1b)
% 	p(6)	SJ1a-SJ1b
% 
% 	p(7)	SJ_c
% 	p(8)	inverse lifetime gamma (= energy half-width)
% 	p(19)	0 if S(Q,w) as theory, =1 if multiply S(Q,w) by energy transfer
% 	p(20)	0 if twinned; 1 if twin #1 ; -1 if twin #2

% If icross=207
% As cross-section 204, but deal with J1a, J1b, J2 directly.

s_eff = p(1);
sj_1a = p(4);
sj_1b = p(5);
sj_2  = p(6);
sj_c  = p(7);
sjplus = sj_1a+(2.*sj_2);
sjminus = (2.*sj_2)-sj_1b;
sk_ab = 0.5.*(sqrt((sjplus+sj_c).^2 + 10.5625) - (sjplus+sj_c));
sk_c  = sk_ab;
gam   = p(8);
temp=4;

alatt=[5.57,5.51,12.298];
arlu=2*pi./alatt;
qsqr = (qh*arlu(1)).^2 + (qk*arlu(2)).^2 + (ql*arlu(3)).^2;


weight=zeros(size(qh));

%First twin:
a_q = 2.*( sj_1b.*(cos(pi.*qk)-1) + sj_1a + 2.*sj_2 + sj_c ) + (3.*sk_ab+sk_c);
d_q = 2.*( sj_1a.*cos(pi.*qh) + 2.*sj_2.*cos(pi.*qh).*cos(pi.*qk) + sj_c.*cos(pi.*ql) );
c_anis = sk_ab-sk_c;

wdisp1 = sqrt(abs(a_q.^2-(d_q+c_anis).^2));
%wdisp2 = sqrt(abs(a_q.^2-(d_q-c_anis).^2));

s_yy = s_eff.*((a_q-d_q-c_anis)./wdisp1);

end