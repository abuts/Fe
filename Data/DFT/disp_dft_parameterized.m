function wdisp = disp_dft_parameterized(qh,qk,ql,en,varargin)
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

persistent hi_grid;
persistent q_axis;
persistent e_axis;
persistent magFF;
A = varargin{1};
if numel(A)>1
    use_magff =A(2);
    A = abs(A(1))/pi;
else
    use_magff = varargin{2}/pi;
end
if isempty(hi_grid)
    e_max = 680;
    path = fileparts(mfilename('fullpath'));
    if nargin > 6
        hi_grid = varargin{3};
    else
        disp('*** loading dft_data for interpolation ****>')
        hi_grid= load(fullfile(path,'Volume.mat'),'dat');
        hi_grid = hi_grid.dat;
        disp('*** loading completed  <*****')
    end
    q0 = 1;
    %-0.7029    1.4075
    q_axis = single(0:q0/100:q0);
    e_axis = single(0:e_max/500:e_max);
    
    a0 = 2.845;
    bm = bmatrix ([a0,a0,a0],[90,90,90]);
    mi = MagneticIons('Fe0');
    magFF = mi.getFF_calculator(bm);
end
sz = size(qh);
if min(size(qh)) ~= 1
    do_reshape = true;
    nip = numel(qh);
    qh = reshape(qh,nip,1);
    qk = reshape(qk,nip,1);
    ql = reshape(ql,nip,1);
    if numel(en) == 1
        en = repmat(en,nip,1);
    else
        en = reshape(en,numel(qh),1);
    end
else
    do_reshape = false;
    if numel(en) == 1
        en = repmat(en,numel(qh),1);        
    end
end
qr = [qh,qk,ql];
%
% move all vectors into 0-1 quadrant where the interpolant is defined.
brav = fix(qr);
brav = brav+sign(brav);
brav = (brav-rem(brav,2));
%
qr   = single(abs(qr-brav));
enr  = single(en);

wdisp = interpn(q_axis,q_axis ,q_axis ,e_axis,hi_grid,...
    qr(:,1),qr(:,2),qr(:,3),enr,'linear',-1);
clear qr;
clear enr;

if use_magff
    ff  = A*magFF(qh,qk,ql,en,[]);
    wdisp = wdisp.*ff';
else
    wdisp = wdisp*A;
end
if do_reshape
    wdisp = reshape(wdisp,sz);
end

if numel(sz)>2 && ~do_reshape
    wdisp = reshape(wdisp,sz);
end

