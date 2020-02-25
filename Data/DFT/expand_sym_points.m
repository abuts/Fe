function [pxs,pys,pzs,ses] = expand_sym_points(px,py,pz,se,combine_with_1D,visualize)

if ~exist('visualize','var')
    visualize = false;
else
    visualize = true;
end
%[px,py,pz,se] = add_missing_points(px,py,pz,se);
if combine_with_1D
    [qx1,qy1,qz1,Es1] = read_allLin_Kun();
    retained = true(size(qx1));
    % remove energy scale from disp calculations
    Es1  = cellfun(@(x)(x(:,2)),Es1,'UniformOutput',false);
    [px,py,pz,se] = expand_points(px,py,pz,se,retained,qx1,qy1,qz1,Es1);
    np = numel(pz);
end
if visualize
    name = sprintf('Base image contains %d points',np);
    figure('Name',name)
    c = cellfun(@(cl)sum_valid(cl),se,'UniformOutput',true);
    scatter3(px,py,pz,8,c);
end


% pxs = px;
% pys = py;
% pzs = pz;
% ses = se;
% return;


proj1 = [0,0,0;1/sqrt(2),-1/sqrt(2),0];
proj2 = [0.5,0.5,0;1/sqrt(2),1/sqrt(2),0];

proj = {proj1,proj2};
%rot0 = {{3,[0.5,0.5,0],90},{3,[0.5,0.5,0],180}};
%proj = {proj2,proj1};
if size(px,1) == 1
    px = px';
    py = py';
    pz = pz';
end
np = numel(pz);
disp([' NP_rec0: ',num2str(np)]);

for i=1:numel(proj)
    [pxe,pye,pze,retained]=reflect_points([px,py,pz],proj{i});
    %rota = rot0{i};
    %[pxe,pye,pze,retained]=rotate_points([px,py,pz],rota{:});
    [px,py,pz,se] = expand_points(pxe,pye,pze,se,retained,px,py,pz,se);
    np = numel(pz);
    if visualize
        name = sprintf('Inv transf N%d; Recovered %d points',i,np);
        figure('Name',name)
        c = cellfun(@(cl)sum_valid(cl),se,'UniformOutput',true);
        scatter3(px,py,pz,8,c);
    end
    disp([' NP_rec',num2str(i),': ',num2str(np)]);
end

rot1 = {{2,[0.5,0.5,0.5],90};{2,[0.5,0.5,0.5],-90};{2,[0.5,0.5,0.5],180};...
    {1,[0.5,0.5,0.5],90};{1,[0.5,0.5,0.5],-90}};
rot2 = {{1,[0,0.5,0.5],90};{1,[0,0.5,0.5],90};{};...
    {2,[0.5,0,0.5],90};{2,[0.5,0,0.5],90}};

pxs = px;
pys = py;
pzs = pz;
ses = se;
for i=1:numel(rot1)
    %[pxe,pye,pze,retained]=reflect_points([px,py,pz],proj{i});
    rota = rot1{i};
    rotb = rot2{i};
    
    if isempty(rotb)
        r_rot=rotate_points([px,py,pz],rota{:});
    else
        r_rot=rotate_points([px,py,pz],rota{:});
        r_rot=rotate_points(r_rot,rotb{:});
    end
    [r_rot,retained]=remove_duplicates([px,py,pz],r_rot);
    pxe = r_rot(:,1);
    pye = r_rot(:,2);
    pze = r_rot(:,3);
    
    
    [pxs,pys,pzs,ses] = expand_points(pxe,pye,pze,ses,retained,pxs,pys,pzs,ses);
    np = numel(pzs);
    if visualize
        name = sprintf('Inv transf N%d, Recovered %d points',i,np);
        figure('Name',name)
        c = cellfun(@(cl)sum_valid(cl),ses,'UniformOutput',true);
        scatter3(pxs,pys,pzs,8,c);
    end
    disp([' NP_rec',num2str(i),': ',num2str(np)]);
end

bin_size = 0.0111379;

n_bins = floor(1/bin_size)+1;
bin3 = floor([pxs,pys,pzs]/bin_size)+1;
bin  = bin3*[1;n_bins;n_bins*n_bins];

[bin,ui] = unique(bin);
pxs = pxs(ui);
pys = pys(ui);
pzs = pzs(ui);
if ~isempty(ses)
    ses = ses(ui);
    if combine_with_1D
        bin3_1 = floor([qx1,qy1,qz1]/bin_size)+1;
        bin1 = bin3_1*[1;n_bins;n_bins*n_bins];
        [bin1,uniqi] = unique(bin1);
        expanded = ismember(bin,bin1);
        
        ses(expanded) = Es1(uniqi);
    end
end
disp([' Finally retained',num2str(numel(pxs)),' : points, rejected ',num2str(np-numel(pxs)),' points']);




function r_rot=rotate_points(pr,dir,rot_cen,angdeg)
%
rx =@(angdeg)( [1,0,0;0,cosd(angdeg),-sind(angdeg);0,sind(angdeg),cosd(angdeg)]);
ry =@(angdeg)( [cosd(angdeg),0,sind(angdeg);0,1,0;-sind(angdeg),0,cosd(angdeg)]);
rz =@(angdeg)( [cosd(angdeg),-sind(angdeg),0;sind(angdeg),cosd(angdeg),0;0,0,1;]);
f_all = {rx,ry,rz};

%pts = unique(sort(pr(:,1)));
%bins = abs(pts(2:end)-pts(1:end-1));

%bin0 = sort(bin0);
%dir = find(c_ax);

rf = f_all{dir};
rm = rf(angdeg);
r_rot = (pr-rot_cen)*rm+rot_cen;


function [pr2r,retained]=remove_duplicates(pr1,pr2,bin_size)

if ~exist('bin_size','var')
    bin_size = 0.0111379;
end

n_bins = floor(1/bin_size)+1;
bin03 = floor(pr1/bin_size);
bin0  = bin03*[1;n_bins;n_bins*n_bins];

bin3 = floor(pr2/bin_size);
bin1  = bin3*[1;n_bins;n_bins*n_bins];
%[bin1,ic] = sort(bin1);
retained = ~ismember(bin1,bin0);
rem = sum(~retained);
disp([' from transfornmed ',num2str(numel(bin1)),' points : ',num2str(rem),' removed']);
pr2r = pr2(retained,:);

function [pxe,pye,pze,moved]=reflect_points(pr,proj)
e0 = proj(1,:);
e1 = proj(2,:);
P = (pr-e0)*e1';
moved = abs(P)>1.e-6;

r_refl = pr-2*P*e1;
pxe = r_refl(moved,1);
pye = r_refl(moved,2);
pze = r_refl(moved,3);

function [px_s,py_s,pz_s,se_s] = add_missing_points(px,py,pz,se)
%
% generate reference points:
[px_s,py_s,pz_s,Xj] = min_sym_pointsQ(21);
% find what real points are present among reference points
bin_size = min(Xj);
nBins = max(floor(Xj/bin_size))+1;
qr_r = [px_s,py_s,pz_s];
bin_r  = floor(qr_r/bin_size)*[1;nBins;nBins*nBins];
bin_s = floor([px,py,pz]/bin_size)*[1;nBins;nBins*nBins];
present = ismember(bin_r,bin_s);
if isempty(se)
    se_s = {};
else
    % copy existing point values into expanded points
    se_s = cell(numel(pz_s),1);
    se_s(present) = se;
end
function ss = sum_valid(Int)
if isempty(Int)
    ss = 0;
    return;
end
valid = ~isnan(Int);
if ~any(valid)
    ss = 0;
    return;
end
sig = Int(valid);
%ss = sum(sig)/sum(valid);
ss = max(sig);