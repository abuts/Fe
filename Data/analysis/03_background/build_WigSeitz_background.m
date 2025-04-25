function data = build_WigSeitz_background(pageop_obj,r2_ignore,rlu)
%build_bz_background used to build background out of q-values beyond of the
% 
%
data = pageop_obj.page_data;
%Q2 = data(1,:).*data(1,:)+data(2,:).*data(2,:)+data(3,:).*data(3,:);
%keep = Q2>=r2_ignore; % background
keep = data(4,:)>-5&data(4,:)<5; %Q2>=r2_ignore; % background
%keep = Q2<r2_ignore;   % foreground
data = data(:,keep);
if isempty(data)
    return;
end
img_crd = pageop_obj.proj.transform_pix_to_img(data(1:3,:));

q = img_crd(1,:);
invert    = q<0;
q = q(~invert);
data = data(:,~invert);
img_crd = img_crd(:,~invert);
%q(invert) = -q(invert);
img_crd(1,:) = rem(q,rlu(1));

q = img_crd(2,:);
invert    = q<0;
q = q(~invert);
data = data(:,~invert);
img_crd = img_crd(:,~invert);
%q(invert) = -q(invert);
img_crd(2,:) = rem(q,rlu(2));

q = data(3,:);
invert    = q<0;
q = q(~invert);
data = data(:,~invert);
img_crd = img_crd(:,~invert);

%q(invert) = -q(invert);
img_crd(3,:) = rem(q,rlu(3));
%
data(1:3,:) = pageop_obj.proj.transform_img_to_pix(img_crd);
end