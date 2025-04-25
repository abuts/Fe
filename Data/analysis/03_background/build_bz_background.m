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

q = data(1,:);
invert    = q<0;
q(invert) = -q(invert);
data(1,:) = rem(q,rlu(1));

q = data(2,:);
invert    = q<0;
q(invert) = -q(invert);
data(2,:) = rem(q,rlu(2));

q = data(3,:);
invert    = q<0;
q(invert) = -q(invert);
data(3,:) = rem(q,rlu(3));
end