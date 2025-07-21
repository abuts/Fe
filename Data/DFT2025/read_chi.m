plist = 'H5P_DEFAULT';
fileName = 'e:/SHARE/Fe/Data/DFT2025/chipm_rsa_fe2.h5';
fid = H5F.open(fileName);
if ~isa('chi_data','var')
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

    chi_data = H5D.read(dset_id,'H5ML_DEFAULT','H5S_ALL',file_space_id,plist);
    H5D.close(dset_id);
    H5F.close(fid);
end
q = h5read(fileName,'/q');
w = h5read(fileName,'/realw');
dW = min(w(2:end)-w(1:end-1));

Ry2meV = 13605.693;

e_scale = w*Ry2meV;

% beta*h*w = E(meV)/k_b*T = E*1.451 T=8K
scaler = (72.65/(dW*RyTomEv*4*pi)/pi)./(1-exp(-1.451*e_scale)); %72.65 mb  -- scaling constant;
scaler(1)=0;

n_w = numel(w);
ab = line_axes('nbins_all_dims',[25,25,25,n_w],'img_range',[-0.02,-0.02,-0.02,-0.5*dw;0.96+0.02,0.96+0.02,0.96+0.02,max(w)*Ry2meV]);
proj = line_proj('alatt',2.867,'angdeg',90);
img11 = d4d(ab,proj);

ds = squeeze(chi_data.i(1,1,:,:));
img11.npix = 1;
img11.s = -reshape((ds.*repmat(scaler,1,size(ds,2)))',25,25,25,n_w);

% data comparison
proj11 = line_proj([1,1,0],[-1,1,0]);
w2t = cut(img11,proj11,[],[-0.02,0.02],[-0.02,0.02],[0,1,400]);
plot(w2t); keep_figure;
w2t = cut(img11,line_proj,[],[],[-0.02,0.02],[90,110]);
plot(w2t); keep_figure;

fexp = 'e:\SHARE\Fe\Data\sqw\sqw2024\Fe_ei401_noBg_4D_reducedBZ_FF_corr_filt_remove.sqw';
src_exp = sqw(fexp);
w2e = cut(src_exp,proj11,0.02,[-0.1,0.1],[-0.1,0.1],[0,5,400]);
plot(w2e); keep_figure;
w2e = cut(src_exp,line_proj,0.02,0.02,[-0.04,0.04],[90,110]);
plot(w2e); keep_figure;
src_raw = 'e:\SHARE\Fe\Data\sqw\sqw2024\Fe_ei401_no_bg_4D.sqw';
srcr = sqw(src_raw);
w2e = cut(srcr,line_proj,0.04,0.04,[-0.04,0.04],[90,110]);
plot(w2e); keep_figure;