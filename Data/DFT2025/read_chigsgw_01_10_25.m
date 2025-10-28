
fileName = 'e:/SHARE/Fe/Data/DFT2025/01_10_2025/dataset2-nk50-conventional-29sep25/chipm_qsgw_conv_nk50.h5 ';
if ~isa('chi_gsgw_data','var')
    plist = 'H5P_DEFAULT';
    fid = H5F.open(fileName);
    dset_id = H5D.open(fid,'/chi_rsa_im');

    file_space_id = H5D.get_space(dset_id);

    chi_gsgw_data = H5D.read(dset_id,'H5ML_DEFAULT','H5S_ALL',file_space_id,plist);
    H5D.close(dset_id);
    H5F.close(fid);
end
q = h5read(fileName,'/q');
w = h5read(fileName,'/realw');
dW = min(w(2:end)-w(1:end-1));

Ry2meV = 13605.693;

e_scale = w*Ry2meV;
dw = dW*Ry2meV;
% beta*h*w = E(meV)/k_b*T = E*1.451 T=8K
%scaler = (72.65/(dW*RyTomEv*4*pi)/pi)./(1-exp(-1.451*e_scale)); %72.65 mb  -- scaling constant;
scaler(1)=0;

n_w = numel(w);
ab = line_axes('nbins_all_dims',[50,50,50,n_w],'img_range',[-0.01,-0.01,-0.01,-0.5*dw;0.98+0.01,0.98+0.01,0.96+0.01,max(w)*Ry2meV]);
proj = line_proj('alatt',2.867,'angdeg',90);
img11 = d4d(ab,proj);

ds = -reshape(chi_gsgw_data',50,50,50,1000);
img11.npix = 1;
img11.s = ds;

% data comparison
proj11 = line_proj([1,1,0],[-1,1,0]);
w2t = cut(img11,proj11,[],[-0.02,0.02],[-0.02,0.02],[0,1,400]);
plot(w2t); keep_figure;
w2t = cut(img11,[],[],[-0.02,0.02],[90,110]);
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