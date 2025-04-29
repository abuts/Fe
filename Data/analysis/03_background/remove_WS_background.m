function sig_var = remove_WS_background(pageop_obj,bg_data,bg_model,rlu)
%
data  = pageop_obj.page_data;
if numel(bg_model.GridVectors)==2
    % 2D background
    pix   = bg_data.proj.transform_pix_to_img(data(1:5,:));
    bg_signal = bg_model(pix(2,:),data(4,:));
elseif numel(bg_model.GridVectors)==4
    pixt = bg_data.proj.transform_pix_to_img(data(1:3,:));

    scale = 2*rlu;
    img_shift = round(pixt ./scale).*scale; % BRAGG positions in the new lattice
    pixt = pixt -img_shift;
    
    bg_signal = bg_model(pixt(1,:),pixt(2,:),pixt(3,:),data(4,:));
    out_of_range = isnan(bg_signal);
    bg_signal(out_of_range) = 0;
else
    %1D background
    bg_signal = bg_model(data(4,:));
end
sig_var = data([8,9],:);
sig_var(1,:) = data(8,:)-bg_signal;
over_compensated = sig_var(1,:)<0;
%sig_var(1,over_compensated) = 0;
sig_var(2,over_compensated) = 0;

end