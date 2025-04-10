function data = build_bz_background(pageop_obj,r2_ignore)
%build_bz_background used to build background out of q-values beyond of the
% 
%
data = pageop_obj.page_data;
Q2 = data(1,:).*data(1,:)+data(2,:).*data(2,:)+data(3,:).*data(3,:);
%keep = Q2>=r2_ignore;
keep = Q2<r2_ignore;
data = data(:,keep);
if isempty(data)
    return;
end
alatt = 2*pageop_obj.img.alatt(:);

q = data(1,:);
invert    = q<0;
q(invert) = -q(invert);
data(1,:) = rem(q,alatt(1));

q = data(2,:);
invert    = q<0;
q(invert) = -q(invert);
data(2,:) = rem(q,alatt(2));

q = data(3,:);
invert    = q<0;
q(invert) = -q(invert);
data(3,:) = rem(q,alatt(3));
end