function wdisp = disp_dft_parameterized(qh,qk,ql,en,varargin)
% interplate and expand numerical DFT data over whole q-dE space
%
% Use this function as model for Tobyfit or sqw_eval or func_eval
% algorithms.

persistent hi_grid;
persistent q_axis;
persistent e_axis;
persistent magFF;
A = varargin{1};
if numel(A)>1
    use_magff =A(2);
    A = A(1)/pi;
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
        disp('*** completed loading <*****')
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


