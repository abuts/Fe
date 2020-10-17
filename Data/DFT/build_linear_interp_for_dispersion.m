function build_linear_interp_for_dispersion

E_range = 0:8:800;
q=0:0.01:1;
nq = numel(q);
dat = zeros(nq,nq,nq,numel(E_range));
[h,k,l] = meshgrid(q,q,q);
nqq = numel(h);
h = reshape(h,nqq,1);
k = reshape(k,nqq,1);
l = reshape(l,nqq,1);
for i=1:numel(E_range)
    en = ones(nqq,1)*E_range(i);
    disp = disp_dft_kun4D_lint(h,k,l,en,[pi,0]);
    disp = reshape(disp,nq,nq,nq);
    dat(:,:,:,i) = disp;
end
save('kun_disp_lint','dat')