datasets = {'GH.dat'};

%calc_arr = repmat(IX_dataset_2d(),numel(datasets),1);
px = [];
py = [];
pz = [];
Es = {};
for i=1:numel(datasets)
    [ds,~,qx,qy,qz,dE,Sig] = read_kun(datasets{i},true,false);
end
plot(ds)
[qx,qy,qz,En,Sig] = read_add_sim();
[qx,qy,qz,es] = compact3D(En,qx,qy,qz,Sig);

nx = qy< 0.01;
qrx = qx(nx);
esx = es(nx);
en_pts = 8:8:800;
ses = cellfun(@(cl)expand_sim(cl,en_pts),esx,'UniformOutput',false);
ses = [ses{:}];
ses = ses';

cont = IX_dataset_2d(qrx,en_pts,ses);
plot(cont)


function sexp = expand_sim(serr,en_range)
if isempty(serr)
    sexp  = NaN(numel(en_range),1);
    return;
end
is = ismember(en_range,serr(:,1));
sexp = NaN(numel(en_range),1);
if sum(is) ~=size(serr,1)
    return
else
    sexp(is) = serr(:,2);
end
end