% script loads data linearly interpolated on 
% chebyshev's grid + hight quality calculation
% along high symmetry directions. The interpolation occured within 
% [0,0,0],[1,1,1] cube in hkl.
% 
if ~exist('kun_interp_volume_dat','var')
    kun_interp_volume_dat = load('Volume.mat');
end
ab = line_axes('nbins_all_dims',[101,101,101,501],'img_range', ...
    [-0.005,-0.005,-0.005,4; ...
    1+0.005,1+0.005,1+0.005,804]);
lp = line_proj('alatt',2.845,'angdeg',90);
kund = d4d(ab,lp);
kund.s = kun_interp_volume_dat.dat;
kund.e = 1;
kund.npix = 1;
% cut the data to be able to see 3D dispersion visually using Horace
d3dkun = cut(kund,[],[],[-0.05,0.05],[])