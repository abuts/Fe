function view_Kuns_add_sim
% function to test Kun simulations loading and expansion
% into {[0,0,0];[1,1,1]} square
%
[s,qx,~,pxs,pys,pzs,en]=read_add_sim_Kun(true);

if numel(size(s)) == 4
    [X,Y] = meshgrid(qx,qx);
    surf(X,Y,s(:,:,1,1));
    surf(X,Y,squeeze(s(:,1,:,1)));
    surf(X,Y,s(:,:,1,10));
    surf(X,Y,squeeze(s(:,1,:,10)));
    surf(X,Y,s(:,:,1,50));
    surf(X,Y,squeeze(s(:,1,:,50)));
    surf(X,Y,s(:,:,1,80));
    surf(X,Y,squeeze(s(:,1,:,80)));
    
    surf(X,Y,s(:,:,5,1));
    surf(X,Y,s(:,:,5,10));
    surf(X,Y,s(:,:,5,50));
    surf(X,Y,s(:,:,5,80));
    surf(X,Y,s(:,:,10,1));
    surf(X,Y,s(:,:,10,10));
    surf(X,Y,s(:,:,10,50));
    surf(X,Y,s(:,:,10,80));
    surf(X,Y,s(:,:,15,1));
    surf(X,Y,s(:,:,15,10));
    surf(X,Y,s(:,:,15,50));
    surf(X,Y,s(:,:,15,80));
    
else
    method = 'natural';
    qq = 0:0.001:1;
    [X,Y] = meshgrid(qq,qq);
    
    [x,y,v]=extract_in_plainZ(pxs,pys,pzs,en,s,40.1,0);
    F = scatteredInterpolant(x,y,v,method);
    S = F(X,Y);
    surf(X,Y,S,'EdgeColor','none');
    
    [x,y,v]=extract_in_plainZ(pxs,pys,pzs,en,s,80.1,0);
    F = scatteredInterpolant(x,y,v,method );
    S = F(X,Y);
    surf(X,Y,S,'EdgeColor','none');
    
    [x,y,v]=extract_in_plainZ(pxs,pys,pzs,en,s,100,0);
    F = scatteredInterpolant(x,y,v,method );
    S = F(X,Y);
    surf(X,Y,S,'EdgeColor','none');
    
    [x,y,v]=extract_in_plainZ(pxs,pys,pzs,en,s,200.1,0);
    F = scatteredInterpolant(x,y,v,method );
    S = F(X,Y);
    surf(X,Y,S,'EdgeColor','none');
    
    [x,y,v]=extract_in_plainZ(pxs,pys,pzs,en,s,500.1,0);
    F = scatteredInterpolant(x,y,v,method );
    S = F(X,Y);
    surf(X,Y,S,'EdgeColor','none');
    
end
%qx = reshape(qr(:,1),21,21,21);
%qy = reshape(qr(:,2),21,21,21);
%qz = reshape(qr(:,3),21,21,21);
function [x,y,ss]=extract_in_plainZ(pxs,pys,pzs,en,s,T0,z0)
dq = 0.02;
dT = 8;
inz = pzs>=z0-dq & pzs<z0+dq;
x = pxs(inz);
y = pys(inz);
%indE = floor(en/dT);
if size(s,2) > 1
    iT0 = floor(T0/dT);
    ss = s(iT0,inz)';
else
    ss = s(inz);
    en = en(inz);
    ine = en>=T0-0.5*dT & en < T0+0.5*dT;
    x = x(ine);
    y = y(ine);
    ss = ss(ine);
end
%c = ss;
%scatter3(x,y,ss,8,c,'filled');
