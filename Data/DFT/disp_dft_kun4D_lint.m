function wdisp = disp_dft_kun4D_lint(qh,qk,ql,en,varargin)
% interpolate and expand numerical DFT data over whole q-dE space using
% Matlab 
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


persistent magFF;
persistent ses;
persistent Interp_array;
persistent en_pts;
en_bin_size = 8; % step of the bin calculation
A = varargin{1};

if numel(A)>1
    use_magff =A(2);
    Amp = abs(A(1))/pi;
else
    use_magff = varargin{2}/pi;
end

if isempty(magFF) && use_magff
    %fcc_igrid = FCC_Igrid();
    
    a0 = 2.845;
    bm = bmatrix ([a0,a0,a0],[90,90,90]);
    mi = MagneticIons('Fe0');
    magFF = mi.getFF_calculator(bm);
end
%
if isempty(ses) || isempty(Interp_array)    
    [ses,~,en_pts,qxs,qys,qzs,ens]=read_add_sim_Kun(true);
    Interp_array = build_ScattInt(en_pts,qxs,qys,qzs,ens,ses);
end
% if numel(A) > 2
%     fcc_igrid.panel_dir = A(3);
%     fcc_igrid.equiv_sym = A(4);
% end
% if numel(A) > 4
%     fcc_igrid.cut_width = A(5);
% end
%-------------------------------------------------------------------------
%do_reshape = false;

qr = [qh,qk,ql];
%
% move all vectors into 0-1 quadrant where the interpolant is defined.
brav = fix(qr);
brav = brav+sign(brav);
brav = (brav-rem(brav,2));
%
%
qr   = double(abs(qr-brav));
enr  = double(en);
wdisp = interpLintKun(qr,enr,Interp_array,en_pts,en_bin_size);
% [wdisp,close_enourh] = fcc_igrid.calc_sqw_in_qube(qr,enr);

if use_magff
    ff  = Amp*magFF(qh,qk,ql,en,[]);
    wdisp = wdisp.*ff';
else
    wdisp = wdisp*Amp;
end
% if do_reshape
%     wdisp = reshape(wdisp,sz);
% end

function wdisp = interpLintKun(qr,enr,Interp_array,en_pts,en_bin_size)

e0 = en_pts(1);
bin0 = round((enr-e0)/en_bin_size)+1;
out_min = bin0<1;
bin0(out_min) = 1;
nbin_max = numel(en_pts);
out_max = bin0>nbin_max;
if sum(out_max)>0
    bin0(out_max) = nbin_max;
end


bin_range = unique(bin0);
wdisp = zeros(numel(enr),1);
for i=1:numel(bin_range)
    n_bin = bin_range(i);
    this_en = bin0 == n_bin;
    qri = qr(this_en,:);
    f1 = Interp_array{n_bin};
    %wd_lin = f1(qri(:,1),qri(:,2),qri(:,3));
    %wd_lin = wd1 + (de/en_bin_size).*wd2;
    %wd_lin = wd1 + (de/en_bin_size).*wd2;
    wdisp(this_en) = f1(qri(:,1),qri(:,2),qri(:,3));
end

