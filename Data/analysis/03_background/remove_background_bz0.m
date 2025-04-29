function data = remove_background_bz0(pageop_obj,bg_data,bg_model,rlu,r2_ignore,fJi)
%
data  = pageop_obj.page_data;
q_coord = data(1:3,:);
Q2 = q_coord(1,:).*q_coord(1,:)+q_coord(2,:).*q_coord(2,:)+q_coord(3,:).*q_coord (3,:);
keep = Q2<r2_ignore;   % foreground
data = data(:,keep);
if isempty(data)
    return;
end
q2 = Q2(keep)/(16*pi*pi);
clear Q2;

scale = 2*rlu;

img_shift   = round(q_coord./scale(:)).*scale(:); % BRAGG positions in the new lattice
q_coord  = q_coord - img_shift;
invert = q_coord<0;
q_coord(invert) = -q_coord(invert);

q4 = data(4,:);
bg_signal = bg_model(q_coord(1,:),q_coord(2,:),q_coord(3,:),q4);
out_of_range = isnan(bg_signal);
bg_signal(out_of_range) = 0;

% Calculate magnetic form factor.
sig_var = data([8,9],:);
%

MFF = fJi{1}(q2).^2+fJi{2}(q2).^2+fJi{3}(q2).^2+fJi{4}(q2).^2;

sig_var(1,:) = (data(8,:)-bg_signal)./MFF;
over_compensated = sig_var(1,:)<0;
sig_var(1,over_compensated) = 0;
sig_var(2,over_compensated) = 0;


data(1:3,:) = q_coord;
data(8:9,:) = sig_var;

end