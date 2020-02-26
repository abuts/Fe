function r_rot=rotate_points(pr,dir,rot_cen,angdeg)
% Rotate points around vector, parallel to one of 3 cartezian axis.
% Inputs:
% pr -- 3xNpoints in 3D space
% dir -- 1,2 or 3 -- selector for one of the rotation axis
% rot_cen -- centre of rotation : row vector of 3 elements
%                                (size(rot_cet)=[1,3])
% angdeg  -- rotation angle in deg
%
persistent f_all;
if isempty(f_all)
    rx =@(angdeg)( [1,0,0;0,cosd(angdeg),-sind(angdeg);0,sind(angdeg),cosd(angdeg)]);
    ry =@(angdeg)( [cosd(angdeg),0,sind(angdeg);0,1,0;-sind(angdeg),0,cosd(angdeg)]);
    rz =@(angdeg)( [cosd(angdeg),-sind(angdeg),0;sind(angdeg),cosd(angdeg),0;0,0,1;]);
    f_all = {rx,ry,rz};
end


rf = f_all{dir};
rm = rf(angdeg)'; % transposed as we multiplying from the left rather then from the right as rotation above is specified
r_rot = (pr-rot_cen)*rm+rot_cen;
