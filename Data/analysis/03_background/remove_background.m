function sig_var = remove_background(pageop_obj,bg_data,bg_model,scale)
%
data  = pageop_obj.page_data;
if numel(bg_model.GridVectors)==2
    % 2D background
    pix   = bg_data.proj.transform_pix_to_img(data(1:5,:));
    bg_signal = bg_model(pix(2,:),pix(4,:));
elseif numel(bg_model.GridVectors)==4
    q_coord = data(1:3,:);
    img_shift   = round(q_coord./scale(:)).*scale(:); % BRAGG positions in the new lattice
    q_coord  = q_coord - img_shift;
    invert = q_coord<0;
    %mam = max(q_coord');
    %shift = repmat(rlu',1,size(data,2));
    %q_coord(invert) = q_coord(invert)+shift(invert);
    q_coord(invert) = -q_coord(invert);
    
    bg_signal = bg_model(q_coord(1,:),q_coord(2,:),q_coord(2,:),data(4,:));
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