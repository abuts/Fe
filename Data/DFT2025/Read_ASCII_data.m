s = readlines('rsj_x0inv.fe2');
n_rows = 52265;
n_header = 7;
n_info = n_rows - n_header;
res = cell(1,n_info);
for i=1:n_info
    res{i} =  sscanf(s(n_header+i),'%f');
end
res = [res{:}]';
x = unique(res(:,3));
y = unique(res(:,4));
z = unique(res(:,5));
s = NaN([numel(x),numel(y),numel(z)]);
e = ones([numel(x),numel(y),numel(z)]);
[X,Y,Z] = meshgrid(x,y,z);
[~,ia,ib] = intersect([X(:),Y(:),Z(:)],res(:,3:5),'rows');
s(ia) = res(ib,6);
all_res = true(n_info,1);
all_res(ib)= false;

add_s = NaN([numel(x),numel(y),numel(z)]);
add_s(ia) = res(all_res,6);

ab =line_axes('nbins_all_dims',[50,50,50,1],'img_range',[min(x),min(y),min(z),-1;max(x),max(y),max(z),1]);
proj = line_proj('alatt',1,'angdeg',90);

pob = d3d(ab,proj);
pob.npix= 1;
pob.s   = s;
pob2 = d3d(ab,proj);
pob2.npix = 1;
pob2.s = add_s;