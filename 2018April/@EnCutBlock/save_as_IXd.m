function [cut,fit_total,background,foreground]=save_as_IXd(obj)
% Exprot en_cut block as sequence of IX_dataset_1d

cut = IX_dataset_1d(obj.cuts_list_(1));
fit_total = IX_dataset_1d(obj.fits_list(1).sum);
background = IX_dataset_1d(obj.fits_list(1).back);
foreground = IX_dataset_1d(obj.fits_list(1).fore);

fname = ['IX_data_',obj.filename];

save(fname,'cut','fit_total','background','foreground');

