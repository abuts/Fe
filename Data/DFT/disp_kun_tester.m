function disp_kun_tester

qq = 0:0.11:5;
en = 5:10:800;
ne = numel(en);
en = repmat(en,1,numel(qq));
qq = repmat(qq,1,ne);
A = [1,0];
ds = disp_dft_kun4D_lint(qq',qq',qq',en',A);
