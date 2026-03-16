fileName = 'e:/SHARE/Fe/Data/DFT2025/01_10_2025/dataset2-nk50-conventional-29sep25/chipm_lda_conv_nk50.h5';
if ~exist("childa_sqw","var")
    childa_sqw = read_jerome_cube(fileName);
end

if ~exist("all_cuts_LDA","var")
    if isfile('all_spaghetti_cuts_LDA.mat')
        load('all_spaghetti_cuts_LDA.mat')
    else
        all_cuts_LDA = spaghetti_cuts4DFT(childa_sqw,true);
        save('all_spaghetti_cuts_LDA.mat','all_cuts_LDA')
    end
end

[calc_arr,labels] = gen_spaghetti_ds(all_cuts_LDA);

spaghetti_plot(calc_arr,'labels',labels);



