function wdisp = disp_dft_kun4D(qh,qk,ql,en,varargin)
% interpolate and expand numerical DFT data over whole q-dE space
%
% Use this function as model for Tobyfit or sqw_eval or func_eval
% algorithms.
% Accepts one or two input parameters:
% Two (or one) elements Array A containing:
% A(1) -- the amplitude of theoretical magnetic scattering, used as fitting parameter to
%         fit theoretical magnetic scattering and the experimental results
% A(2) -- if present and == 1 specifies if one needs to apply magnetic form factor corrections,
%         or ignore these corrections if A(2) == 0
%         if its absent, the magnetic form factor sign should be defined as the second
%         parameter of the function

jn=@(N)(1:N);
Xn =@(N)(0.5-0.5*cos((jn(N)-0.5)*pi/N));

persistent fcc_igrid;
persistent magFF;
A = varargin{1};

if numel(A)>1
    use_magff =A(2);
    Amp = abs(A(1))/pi;
else
    use_magff = varargin{2}/pi;
end
fcc_igrid = FCC_Igrid();
if isempty(magFF) && use_magff
    %fcc_igrid = FCC_Igrid();
    
    a0 = 2.845;
    bm = bmatrix ([a0,a0,a0],[90,90,90]);
    mi = MagneticIons('Fe0');
    magFF = mi.getFF_calculator(bm);
end
if numel(A) > 2
    fcc_igrid.panel_dir = A(3);
    fcc_igrid.equiv_sym = A(4);
end
if numel(A) > 4
    fcc_igrid.cut_width = A(5);
end
%-------------------------------------------------------------------------
[qr,ses]=read_add_sim_Kun('Fe_add_sim.dat');
qr = [qh,qk,ql];
%
% move all vectors into 0-1 quadrant where the interpolant is defined.
brav = fix(qr);
brav = brav+sign(brav);
brav = (brav-rem(brav,2));
%
qr   = single(abs(qr-brav));
enr  = single(en);

% [wdisp,close_enourh] = fcc_igrid.calc_sqw_in_qube(qr,enr);

if use_magff
    ff  = Amp*magFF(qh,qk,ql,en,[]);
    wdisp = wdisp.*ff';
else
    wdisp = wdisp*Amp;
end
if do_reshape
    wdisp = reshape(wdisp,sz);
end




