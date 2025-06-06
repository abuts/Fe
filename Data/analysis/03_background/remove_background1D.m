function data = remove_background1D(pageop_obj,bg_data,bg_model)
%
data  = pageop_obj.page_data;
%pix   = bg_data.proj.transform_pix_to_img(data(1:3,:));

bg_signal = bg_model(data(4,:));
data(8,:) = data(8,:)-bg_signal;
over_compensated = data(8,:)<0;
data(8,over_compensated) = 0;
data(9,over_compensated) = 0;

end