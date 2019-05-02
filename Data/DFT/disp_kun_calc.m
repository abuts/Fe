function wdisp = disp_kun_calc(qh,qk,ql,en,varargin)
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

persistent fcc_igrid;
persistent magFF;
A = varargin{1};
if numel(A)>1
    use_magff =A(2);
    A = abs(A(1))/pi;
else
    use_magff = varargin{2}/pi;
end
if isempty(fcc_igrid)
    fcc_igrid = FCC_Igrid();
    
    a0 = 2.845;
    bm = bmatrix ([a0,a0,a0],[90,90,90]);
    mi = MagneticIons('Fe0');
    magFF = mi.getFF_calculator(bm);
end

if min(size(qh)) ~= 1
    sz = size(qh);
    do_reshape = true;
    
    qh = reshape(qh,numel(qh),1);
    qk = reshape(qk,numel(qh),1);
    ql = reshape(ql,numel(qh),1);
    en = reshape(en,numel(qh),1);
else
    do_reshape = false;
end

wdisp = fcc_igrid.calc_sqw(qh,qk,ql,en);

if use_magff
    ff  = A*magFF(qh,qk,ql,en,[]);
    wdisp = wdisp.*ff';
else
    wdisp = wdisp*A;
end
if do_reshape
    wdisp = reshape(wdisp,sz);
end


