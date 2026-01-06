function data = build_bz_background(pageop_obj,r2_ignore,rlu)
%build_bz_background used to build background out of q-values beyond of the
% 
%
data = pageop_obj.page_data;
Q2 = data(1,:).*data(1,:)+data(2,:).*data(2,:)+data(3,:).*data(3,:);
keep = Q2>=r2_ignore; % background
%keep = Q2<r2_ignore;   % foreground
data = data(:,keep);
if isempty(data)
    return;
end
scale = 2*rlu;
q_coord = data(1:3,:);
img_shift   = round(q_coord./scale(:)).*scale(:); % BRAGG positions in the new lattice
q_coord  = q_coord - img_shift;
invert = q_coord<0;
%mam = max(q_coord');
%shift = repmat(rlu',1,size(data,2));
%q_coord(invert) = q_coord(invert)+shift(invert);
q_coord(invert) = -q_coord(invert);
data(1:3,:) = q_coord;

end