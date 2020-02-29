function view_Kuns_add_sim
% function to test Kun simulations loading and expansion
% into {[0,0,0];[1,1,1]} square
%
[s,qx,en_pts,pxs,pys,pzs,ens]=read_add_sim_Kun(true);

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
    
%     [x,y,v]=extract_in_plainZ(pxs,pys,pzs,en,s,40.1,0);
%     F = scatteredInterpolant(x,y,v,method);
%     S = F(X,Y);
%     surf(X,Y,S,'EdgeColor','none');
    
%     [x,y,v]=extract_in_plainZ(pxs,pys,pzs,en,s,80.1,0);
%     F = scatteredInterpolant(x,y,v,method );
%     S = F(X,Y);
%     surf(X,Y,S,'EdgeColor','none');
    E_l = 100;
    [x,y,v]=extract_in_plainZ(pxs,pys,pzs,ens,s,E_l,0.1);
    F = scatteredInterpolant(x,y,v,method );
    S = F(X,Y);
    surf(X,Y,S,'EdgeColor','none');
    qh = reshape(X,numel(X),1);
    qk = reshape(Y,numel(Y),1);    
    ql = ones(size(qh))*0.1;

    
    bin_size = 8;
    e_min = min(en_pts);
%     %e_ind = floor((en-e_min)/bin_size)+1;   
%     if size(s,2) > 1
%         ind_e = round((E_l-e_min)/bin_size)+1;
%         ss = s(ind_e,:)';        
%         F = scatteredInterpolant(pxs,pys,pzs,ss,method );        
%         S  = F(qh,qk,ql);
%         S = reshape(S,size(X));
%         surf(X,Y,S,'EdgeColor','none');
%     else
%         in_e = ens>=E_l-0.5*bin_size & ens<E_l+0.5*bin_size;
%         pxss = pxs(in_e);
%         pyss = pys(in_e);        
%         pzss = pzs(in_e);
%         ss = s(in_e);
%         F = scatteredInterpolant(pxss,pyss,pzss,ss,method );        
%         S  = F(qh,qk,ql);
%         S = reshape(S,size(X));
%         surf(X,Y,S,'EdgeColor','none');        
%     end
    
%     [x,y,v]=extract_in_plainZ(pxs,pys,pzs,en,s,200.1,0);
%     F = scatteredInterpolant(x,y,v,method );
%     S = F(X,Y);
%     surf(X,Y,S,'EdgeColor','none');
%     
%     [x,y,v]=extract_in_plainZ(pxs,pys,pzs,en,s,500.1,0);
%     F = scatteredInterpolant(x,y,v,method );
%     S = F(X,Y);
%     surf(X,Y,S,'EdgeColor','none');

    %
    en = ones(size(qh))*E_l;
    w = disp_dft_kun4D_lint(qh,qk,ql,en,[1,0]);
    S = reshape(w,size(X));
    figure
    surf(X,Y,S,'EdgeColor','none');    
end
%qx = reshape(qr(:,1),21,21,21);
%qy = reshape(qr(:,2),21,21,21);
%qz = reshape(qr(:,3),21,21,21);
function [x,y,ss]=extract_in_plainZ(pxs,pys,pzs,en,s,dE0,z0)
dq = 0.02;
dE = 8;
inz = pzs>=z0-dq & pzs<z0+dq;
x = pxs(inz);
y = pys(inz);
%indE = floor(en/dT);
if size(s,2) > 1
    iT0 = round((dE0-min(en))/dE)+1;
    ss = s(iT0,inz)';
else
    ss = s(inz);
    en = en(inz);
    ine = en>=dE0-0.5*dE & en < dE0+0.5*dE;
    x = x(ine);
    y = y(ine);
    ss = ss(ine);
end
 c = ss;
 scatter3(x,y,ss,8,c,'filled');
