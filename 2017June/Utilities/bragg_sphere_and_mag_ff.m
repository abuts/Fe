function weight = bragg_sphere_and_mag_ff(mag_ff,qh,qk,ql,en,p,lattice0,lattice,rotvec)
% Blobs at Bragg positions on a lattice rotated and scaled w.r.t. input lattice
%
%   >> weight = make_bragg_blobs (qh,qk,ql,en,p,lattice0)
%   >> weight = make_bragg_blobs (qh,qk,ql,en,p,lattice0,lattice,rotvec)
%
% The purpose of this routine is to enable the spectral weight to be
% calculated for an array of points expressed in the reference lattice, but
% where the blobs are centred on the Bragg points of a true lattice that is
% rotated with respect to the reference lattice.
%
% Input:
% ------
%   qh,qk,ql,en Arrays of h,k,l,e in the reference lattice. The spectral 
%               weight will be calculated for blobs around the Bragg points
%               in the true lattice.
%
%   p           Array of parameters [amp, q_fwhh,e_fwhh]:
%                   amp     Peak intensity of blob
%                   q_fwhh  FWHH of 3D Gaussian in reciprocal space (Ang)
%                   e_fwhh  FWHH in energy (meV)
%
%   lattice0    [a,b,c,alf,bet,gam] lattice parameters (Ang and deg) of the
%               reference lattice
%
%   lattice     Optional: [a,b,c,alf,bet,gam] lattice parameters (Ang and deg)
%               of the true lattice. It is 
%              (Default: lattice0)
%
%   rotvec      Optional: Rotation vector [th1,th2,th3] (rad) of the true
%               lattice with respect to the reference lattice
%              (Default: [0,0,0])
%
% Output:
% -------
%   weight      Array of intensities at the data points

% Author: T.G.Perring

amp=p(1);
qsig=2*p(2)/sqrt(log(256));
RblobSq =p(3);

% Conversion matrix to turn h,k,l into corresponding values for the lattice defined by parameters
% -------------------------------------------------------------------------------------
% b0 is the matrix to convert rlu in the reference lattice to crystal Cartesian coords
[b0,~,~,mess] = bmatrix(lattice0(1:3),lattice0(4:6));
if ~isempty(mess), error(mess), end

% b is the matrix to convert rlu in the true lattice to crystal Cartesian coords
if exist('lattice','var')
    [b,arlu,angrlu,mess] = bmatrix(lattice(1:3),lattice(4:6));
    if ~isempty(mess), error(mess), end
else
    b=b0;
end

if exist('rotvec','var')
    R=rotvec_to_rotmat2(rotvec');
else
    R=eye(3);
end
rlu_corr=b\(R*b0);
ff = mag_ff(qh,qk,ql,[],b0);

% Get h,k,l in new lattice and get weight
qrlu=rlu_corr*[qh,qk,ql]';
hkl = round(qrlu);
valid = mod(sum(hkl,1),2)==0;

dqrlu=qrlu-hkl;
dq=b*dqrlu;     % convert back to orthonormal frame
dq2 = sum(dq.^2,1);
dq =dq.*(1 - sqrt(en'./dq2/RblobSq));

%de  = 
%weight=amp*exp(-(sum((dq/qsig).^2,1) + (en(:)'/esig).^2)/2);
weight=amp*exp(-sum((dq/qsig).^2,1));
weight=reshape(weight,size(qh)).*ff';
weight(~valid) =0;
