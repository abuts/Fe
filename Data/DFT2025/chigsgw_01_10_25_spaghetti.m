fileName = 'e:/SHARE/Fe/Data/DFT2025/01_10_2025/dataset2-nk50-conventional-29sep25/chipm_qsgw_conv_nk50.h5 ';
if ~exist("chigsgw_sqw","var")
    chigsgw_sqw = read_jerome_cube(fileName);
end

directions = {'GH','HN','NG','GP','PN'};
if ~exist("all_cuts_GSGW","var")
    if isfile('all_spaghetti_cuts_GSW.mat')
        load('all_spaghetti_cuts_GSW.mat')
    else 
        all_cuts_GSGW = spaghetti_cuts4DFT(chigsgw_sqw,false);
        save('all_spaghetti_cuts_GSW.mat','all_cuts_GSGW')        
    end
end

[calc_arr,labels] = gen_spaghetti_ds(all_cuts_GSGW);

spaghetti_plot(calc_arr,'labels',labels);



