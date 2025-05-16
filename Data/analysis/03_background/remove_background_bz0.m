function data = remove_background_bz0(pageop_obj,bg_model,rlu,r2_ignore,fJi)
%
% Filter non-magnetic results
data  = pageop_obj.page_data;
q_coord = data(1:3,:);
Q2 = q_coord(1,:).*q_coord(1,:)+q_coord(2,:).*q_coord(2,:)+q_coord(3,:).*q_coord (3,:);
keep = Q2<r2_ignore;   % foreground
data = data(:,keep);
q_coord = q_coord(:,keep);
Q2      = Q2(keep);
if isempty(data)
    return;
end
%
% filter strange secondary reflections
filt_scale = 0.5*rlu;
q_filt = round(q_coord(1:2,:)./filt_scale(1)).*filt_scale(1);
r_filt2 = (0.07*filt_scale(1))^2;
%filter = (q_coord(1,:)-q_filt(1,:)).^2+(q_coord(2,:)-q_filt(2,:)).^2 < r_filt2;
%data(1:2,filter) = 0 ;
keep2 = (q_coord(1,:)-q_filt(1,:)).^2+(q_coord(2,:)-q_filt(2,:)).^2 >= r_filt2;
data = data(:,keep2);
if isempty(data)
    return;
end
q_coord = q_coord(:,keep2);
% Calculate magnetic form factor
q2 = Q2(keep2)/(16*pi*pi);
clear Q2;
MFF = fJi{1}(q2).^2+fJi{2}(q2).^2+fJi{3}(q2).^2+fJi{4}(q2).^2;

sig_var = data([8,9],:);

% move everything into 1/4 of first square zone with basis
scale = 2*rlu;
img_shift = round(q_coord./scale(:)).*scale(:); % BRAGG positions in the new lattice
q_coord   = q_coord - img_shift;
invert = q_coord<0;
q_coord(invert) = -q_coord(invert);

% calculate  background.
q4 = data(4,:);
bg_signal = bg_model(q_coord(1,:),q_coord(2,:),q_coord(3,:),q4);
out_of_range = isnan(bg_signal);
bg_signal(out_of_range) = 0;
% remove background
%sig_var(1,:) = (data(8,:)-bg_signal);
% Correct for Magnetic form factor after background has
% been removed
sig_var(1,:) = (data(8,:)-bg_signal)./MFF;
over_compensated = sig_var(1,:)<0;
sig_var(1,over_compensated) = 0;
sig_var(2,over_compensated) = 0;


data(1:3,:) = q_coord;
data(8:9,:) = sig_var;

end