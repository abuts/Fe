function [px,py,pz,se] = expand_sim_points(px,py,pz,se)
proj1 = [0,0,0;1/sqrt(2),-1/sqrt(2),0];
proj2 = [0.5,0.5,0;1/sqrt(2),1/sqrt(2),0];
ort3 = cross([1,0,0],[0.5,0.5,0.5]);
ort3 = ort3/sqrt(ort3*ort3');

proj3 = [[0,0,0];ort3];
proj = {proj3,proj2,proj1};
if size(px,1) == 1
    px = px';
    py = py';
    pz = pz';
end

for i=1:numel(proj)
    [pxe,pye,pze,moved]=reflect_points([px,py,pz],proj{i});
    [px,py,pz,se] = expand_points(pxe,pye,pze,moved,px,py,pz,se);
    scatter3(px,py,pz);
end


function [pxe,pye,pze,sexp] = expand_points(pxe,pye,pze,moved,px,py,pz,se)
pxe = [px;pxe];
pye = [py;pye];
pze = [pz;pze];
if numel(se) == numel(px)
    sexp = se(moved);
    sexp = [se;sexp];
else
    sexp  = [];
end


function [pxe,pye,pze,moved]=reflect_points(pr,proj)
e0 = proj(1,:);
e1 = proj(2,:);
P = (pr-e0)*e1';
moved = abs(P)>1.e-6;

r_refl = pr-2*P*e1;
pxe = r_refl(moved,1);
pye = r_refl(moved,2);
pze = r_refl(moved,3);