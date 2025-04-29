function data = build_WigSeitz_background(pageop_obj,r2_ignore,rlu)
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
img_crd = pageop_obj.proj.transform_pix_to_img(data(1:3,:));
scale = 2*rlu;
img_shift = round(img_crd./scale).*scale; % BRAGG positions in the new lattice
img_crd = img_crd-img_shift;

data(1:3,:) = pageop_obj.proj.transform_img_to_pix(img_crd);
end