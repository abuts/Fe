function [pxs,pys,pzs,ses] = expand_sim_points(px,py,pz,se)
proj1 = [0,0,0;1/sqrt(2),-1/sqrt(2),0];
proj2 = [0.5,0.5,0;1/sqrt(2),1/sqrt(2),0];
ort3 = cross([1,0,0],[0.5,0.5,0.5]);
ort3 = ort3/sqrt(ort3*ort3');


proj3 = [[0,0,0];ort3];
ort3a = cross([-1/2,0,1/2],[-1/2,1/2,1/2]);
ort3a = ort3a/sqrt(ort3a*ort3a');
proj3a = [[1,0,0];ort3a];
proj = {proj3,proj3a,proj2,proj1};
rot0 = {{3,[0.5,0.5,0],90},{3,[0.5,0.5,0],180}};
%proj = {proj2,proj1};
if size(px,1) == 1
    px = px';
    py = py';
    pz = pz';
end
np = numel(pz);
disp([' NP_rec0: ',num2str(np)]);

for i=1:numel(rot0)
    %[pxe,pye,pze,retained]=reflect_points([px,py,pz],proj{i});
    rota = rot0{i};
    [pxe,pye,pze,retained]=rotate_points([px,py,pz],rota{:});
    [px,py,pz,se] = expand_points(pxe,pye,pze,retained,px,py,pz,se);
    np = numel(pz);
%    name = sprintf('Inv transf N%d; Recovered %d points',i,np);
%    figure('Name',name)
%    scatter3(px,py,pz);
    disp([' NP_rec',num2str(i),': ',num2str(np)]);
end

rot1 = {{2,[0.5,0.5,0.5],90};{2,[0.5,0.5,0.5],-90};{2,[0.5,0.5,0.5],180};...
    {1,[0.5,0.5,0.5],90};{1,[0.5,0.5,0.5],-90}};
pxs = px;
pys = py;
pzs = pz;
ses = se;
for i=1:numel(rot1)
    %[pxe,pye,pze,retained]=reflect_points([px,py,pz],proj{i});
    rota = rot1{i};
    [pxe,pye,pze,retained]=rotate_points([px,py,pz],rota{:});
    [pxs,pys,pzs,ses] = expand_points(pxe,pye,pze,retained,pxs,pys,pzs,ses);
    np = numel(pzs);
    name = sprintf('Inv transf N%d, Recovered %d points',i,np);
    figure('Name',name)
    scatter3(pxs,pys,pzs);
    disp([' NP_rec',num2str(i),': ',num2str(np)]);
end

bin_size = 0.0111379;

n_bins = floor(1/bin_size)+1;
bin3 = floor([pxs,pys,pzs]/bin_size)+1;
bin  = bin3*[1;n_bins;n_bins*n_bins];
[~,ui] = unique(bin);
pxs = pxs(ui);
pys = pys(ui);
pzs = pzs(ui);
if ~isempty(ses)
    ses = ses(ui);
end


function [pxe,pye,pze,sexp] = expand_points(pxe,pye,pze,retained,px,py,pz,se)
pxe = [px;pxe];
pye = [py;pye];
pze = [pz;pze];
if numel(se) == numel(px)
    sexp = se(retained);
    sexp = [se;sexp];
else
    sexp  = [];
end



function [pxe,pye,pze,retained]=rotate_points(pr,dir,rot_cen,angdeg)
%
rx =@(angdeg)( [1,0,0;0,cosd(angdeg),-sind(angdeg);0,sind(angdeg),cosd(angdeg)]);
ry =@(angdeg)( [cosd(angdeg),0,sind(angdeg);0,1,0;-sind(angdeg),0,cosd(angdeg)]);
rz =@(angdeg)( [cosd(angdeg),-sind(angdeg),0;sind(angdeg),cosd(angdeg),0;0,0,1;]);
f_all = {rx,ry,rz};

%pts = unique(sort(pr(:,1)));
%bins = abs(pts(2:end)-pts(1:end-1));
bin_size = 0.0111379;

n_bins = floor(1/bin_size)+1;
bin03 = floor(pr/bin_size);
bin0  = bin03*[1;n_bins;n_bins*n_bins];
%bin0 = sort(bin0);
%dir = find(c_ax);

rf = f_all{dir};
rm = rf(angdeg);
r_rot = (pr-rot_cen)*rm+rot_cen;

bin3 = floor(r_rot/bin_size);
bin1  = bin3*[1;n_bins;n_bins*n_bins];
%[bin1,ic] = sort(bin1);
retained = ~ismember(bin1,bin0);
rem = sum(~retained);
disp([' Rotated ',num2str(numel(bin1)),' points Where : ',num2str(rem),' Coinside']);
pxe = r_rot(retained,1);
pye = r_rot(retained,2);
pze = r_rot(retained,3);

function [pxe,pye,pze,moved]=reflect_points(pr,proj)
e0 = proj(1,:);
e1 = proj(2,:);
P = (pr-e0)*e1';
moved = abs(P)>1.e-6;

r_refl = pr-2*P*e1;
pxe = r_refl(moved,1);
pye = r_refl(moved,2);
pze = r_refl(moved,3);