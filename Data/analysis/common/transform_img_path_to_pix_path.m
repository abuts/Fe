function ds = transform_img_path_to_pix_path(ds,proj)
%TRANSFORM_IMGPATH_TO_PIX_PATH Convert path expressed in image
% coordoinate system to pixel coordinate system and
% modify path present in input IX_dataset 

img_path = proj.u(:)*ds.x;
pix_p = proj.transform_img_to_pix(img_path);
q_path = sqrt(pix_p(1,:).^2+pix_p(2,:).^2+pix_p(3,:).^2);
if q_path(1)>q_path(2)
    [q_path,idx] = sort(q_path);
    ds.signal = ds.signal(idx);
    ds.error  = ds.error(idx);
end
ds.x = q_path/2.84;

end