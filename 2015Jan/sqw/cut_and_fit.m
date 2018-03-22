function [x0,I,Sigma] = cut_and_fit(w2,e0,X0,I,Sigma)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
u = [1,0,0];
[proj.u,proj.v,proj.w]=make_ortho_set(u);
proj.type = 'ppp';
proj.uoffset=[2,0,0,0];
w1=cut_sqw(w2,proj,[-0.05,0.05],[0,0.05,1],[-0.05,0.05],[e0,e0+10]);

[w1fit,t]=fit(w1,@gauss_bkgd,[I,X0,abs(Sigma),0.01,0]);
I = t.p(1);
x0 = t.p(2);
Sigma = t.p(3);

acolor black
plot(w1);
acolor red
pl(w1fit);
keep_figure;
end

