
fileName = 'e:/SHARE/Fe/Data/DFT2025/01_10_2025/dataset2-nk50-conventional-29sep25/chipm_lda_conv_nk50.h5';
if ~exist("childa_sqw","var")
    childa_sqw = read_jerome_cube(fileName);
end

% data comparison
proj11 = line_proj([1,1,0],[-1,1,0]);
w2t = cut(childa_sqw ,proj11,[],[-0.02,0.02],[-0.02,0.02],[0,1,400]);
plot(w2t); keep_figure;
w2t = cut(childa_sqw ,[],[],[-0.02,0.02],[90,110]);
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