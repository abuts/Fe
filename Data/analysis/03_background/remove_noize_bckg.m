function data = remove_noize_bckg(pageop_obj,bg_data,bg_model)
% Remove noisy detectors
data  = pageop_obj.page_data;
%2D background
pix   = bg_data.proj.transform_pix_to_img(data(1:5,:));
bg_signal = bg_model(pix(2,:),data(4,:));
restrict  = bg_signal<20;
bg_signal(restrict) = 0;
%1D background
%bg_signal = bg_model(data(4,:));

data(8,:) = data(8,:)-bg_signal;
over_compensated = data(8,:)<0;
data(8,over_compensated) = 0;
data(9,over_compensated) = 0;

end