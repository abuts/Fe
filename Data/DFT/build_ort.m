function [e1,e2,e3,l1] = build_ort(e0,e1)
% build orthogonal right coordinate system around the vector, defined by
% two input vectors e0 and e1
e01 = e1-e0;
l1 = sqrt(e01*e01');
e1 = e01/l1;
ortz = (e1 == 0);
if any(ortz)
    e2 = zeros(1,3);
    z0 = find(ortz,1);
    e2(z0)= 1;
else
    e2 =[0,-e1(3),e1(2)]/sqrt(e1(3)^2+e1(2)^2);
end
e3 = cross(e1,e2);
