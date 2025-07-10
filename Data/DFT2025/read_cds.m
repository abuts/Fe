plist = 'H5P_DEFAULT';
fileName = 'e:/SHARE/Fe/Data/DFT2025/chipm_rsa_fe2.h5';
fid = H5F.open(fileName);
dset_id = H5D.open(fid,'/chirsa');
% dims = [15625,10001,2,2];
% dtype = H5T.create('H5T_COMPOUND', 16);
% H5T.insert(dtype,'r',0,'H5T_NATIVE_DOUBLE');
% H5T.insert(dtype,'i',8,'H5T_NATIVE_DOUBLE');

%mem_space_id = H5S.create_simple(4,dims,[]);
file_space_id = H5D.get_space(dset_id);
%offset = fliplr([0,0, 0, 0]);
%block = fliplr([10,10,2,2]);
%H5S.select_hyperslab(file_space_id,'H5S_SELECT_SET',offset,[],[],[]);
data = H5D.read(dset_id,'H5ML_DEFAULT','H5S_ALL',file_space_id,plist);
H5D.close(dset_id);
H5F.close(fid);
q = h5read(fileName,'/q');
w = h5read(fileName,'/realw');

n_w = numel(w);
ab = line_axes('nbins_all_dims',[25,25,25,n_w],'img_range',[0,0,0,0;0.96,0.96,0.96,max(w)*13.605]);
proj = line_proj('alatt',2*pi/2.867,'angdeg',90);
img11 = d4d(ab,proj);
img12 = d4d(ab,proj);
img21 = d4d(ab,proj);
img22 = d4d(ab,proj);
re11 = d4d(ab,proj);
re12 = d4d(ab,proj);
re21 = d4d(ab,proj);
re22 = d4d(ab,proj);

ds = squeeze(data.i(1,1,:,:));
img11.npix = 1;
img11.s = -reshape(ds',25,25,25,n_w);

ds = squeeze(data.i(1,2,:,:));
img12.npix = 1;
img12.s = -reshape(ds',25,25,25,n_w);

ds = squeeze(data.i(2,1,:,:));
img21.npix = 1;
img21.s = -reshape(ds',25,25,25,n_w);

ds = squeeze(data.i(2,2,:,:));
img22.npix = 1;
img22.s = -reshape(ds',25,25,25,n_w);

ds = squeeze(data.r(1,1,:,:));
re11.npix = 1;
re11.s = -reshape(ds',25,25,25,n_w);

ds = squeeze(data.r(1,2,:,:));
re12.npix = 1;
re12.s = -reshape(ds',25,25,25,n_w);

ds = squeeze(data.r(2,1,:,:));
re21.npix = 1;
re21.s = -reshape(ds',25,25,25,n_w);

ds = squeeze(data.r(2,2,:,:));
re22.npix = 1;
re22.s = -reshape(ds',25,25,25,n_w);
