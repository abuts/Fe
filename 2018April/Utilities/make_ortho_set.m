function [u,v,w,Norm]=make_ortho_set(u)
% simple function which generate orthogonal right-hand set around
% specified vector

Rot=zeros(3,3,3);
% Rx
Rot(1,1,1)=1;
Rot(2,3,1)=-1;
Rot(3,2,1)=1;
% Ry
Rot(1,3,2)=-1;
Rot(2,2,2)= 1;
Rot(3,1,2)= 1;
%Rz
Rot(3,3,3)=1;
Rot(1,2,3)=-1;
Rot(2,1,3)=1;

[minv,im] = min(abs(u));

Norm = sqrt(u*u');
if Norm<1.e-6
    error('MAKE_ORTHO_SET:invalid_argument',' u can not be 0 vectror')
end

u = u/Norm; %;
wt = (Rot(:,:,im)*u')';
vt = cross(wt,u);
v = vt/sqrt(vt*vt');

w = cross(u,v);


