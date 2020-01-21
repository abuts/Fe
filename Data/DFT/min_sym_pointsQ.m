function [px,py,pz,Xj] = min_sym_pointsQ(Nip,visual)

if exist('visual','var')
    visual = true;
else
    visual = false;
end

jn=@(N)(1:N);
Xn =@(N)(0.5-0.5*cos((jn(N)-0.5)*pi/N));

Xj = Xn(Nip);

[px,py,pz]= meshgrid(Xj,Xj,Xj);

px = reshape(px,numel(px),1);
py = reshape(py,numel(py),1);
pz = reshape(pz,numel(pz),1);
np = numel(pz);
disp([' NP0: ',num2str(np)]);
if visual
    figure('Name',['Initial Points: Npoints: ',num2str(np)])
    scatter3(px,py,pz);
end

ort1 = [1,-1,0];
proj = [px,py,pz]*ort1';
valid = proj>=-1.e-6;
px = px(valid);
py = py(valid);
pz = pz(valid);
%---------------------------------------------------------
np = numel(pz);
if visual
    figure('Name',['NP1; transf 1, left ',num2str(np),' points'])
    scatter3(px,py,pz);
end
disp([' NP1: ',num2str(np)]);


proj2 = ([px,py,pz]-[0.5,0.5,0])*[1;1;0];
valid = proj2<=1.e-6 ;
px = px(valid);
py = py(valid);
pz = pz(valid);
%---------------------------------------------------------
np = numel(pz);
if visual
    figure('Name',['NP2; transf 2, left ',num2str(np),' points'])
    scatter3(px,py,pz);
    ly 0 1
end
disp([' NP2: ',num2str(np)]);




ort3 = cross([1,0,0],[0.5,0.5,0.5]);
proj3 = ([px,py,pz])*ort3';
valid = proj3<=0;
px = px(valid);
py = py(valid);
pz = pz(valid);
%---------------------------------------------------------
np = numel(pz);
if visual
    figure('Name',['NP3; transf 3, left ',num2str(np),' points'])
    scatter3(px,py,pz);
    ly 0 1
end
disp([' NP3: ',num2str(np)]);
