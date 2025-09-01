function sig_var = remove_background_bin_center(pageop_obj,bg_data,bg_model,rlu)
%
data  = pageop_obj.page_data;
if numel(bg_model.GridVectors)==2
    % 2D background
    pix   = bg_data.proj.transform_pix_to_img(data(1:5,:));
    bg_signal = bg_model(pix(2,:),pix(4,:));
elseif numel(bg_model.GridVectors)==4
    step = bg_data.axes.step;
    min_range = pageop_obj.pix.pix_range(1,:);
    min_range(1:3) = 0;

    q1 = data(1,:);
    invert    = q1<0;
    q1(invert) = -q1(invert);
    data(1,:) = rem(q1,rlu(1));

    q2 = data(2,:);
    invert    = q2<0;
    q2(invert) = -q2(invert);
    data(2,:) = rem(q2,rlu(2));

    q3 = data(3,:);
    invert    = q3<0;
    q3(invert) = -q3(invert);
    data(3,:) = rem(q3,rlu(3));
    idx = floor((data(1:4,:)-min_range')./step'+1);
    mmidx = [ones(1,4);bg_data.axes.nbins_all_dims];
    lidx = long_idx(idx,mmidx');
    bg_signal = bg_data.s(lidx);
    %q4 = data(4,:);
    %bg_signal = bg_model(q1,q2,q3,q4);
    %out_of_range = isnan(bg_signal);
    %bg_signal(out_of_range) = 0;
else
    %1D background
    bg_signal = bg_model(data(4,:));
end
sig_var = data([8,9],:);
sig_var(1,:) = bg_signal;
over_compensated = sig_var(1,:)<0;
%sig_var(1,over_compensated) = 0;
sig_var(2,over_compensated) = 0;

end