function sw_plot_from_proj_data(pl_pannels)

n_pannels = numel(pl_pannels);

rlu = [0,0,0;1,0,0;1/2,1/2,0;0,0,0;1/2,1/2,1/2;1/2,1/2,0]';
hp = cell(1,n_pannels);
xp = cell(1,n_pannels);
gap = 0;    %
kB=8.6173324e-2;
gamma = 10;
T = 8;
Seff =1;      %1.4489;
J0 = 25;  
par = [Seff, gap, J0, 5.5, 10, 10.0, 0];

%slinD = repmat(IX_dataset_1d,1,n_pannels);
x_start = 0;
for i=1:n_pannels
    x = 0.5*(pl_pannels(i).x(1:end-1)+pl_pannels(i).x(2:end));
    x_range = min_max(x );
    xp{i} = x+x_start;
    x_start = x_start+x_range(2);

    Np = numel(pl_pannels(i).x)-1;
    hkl = hkl_path_from_proj(Np,rlu,i+1);
    [wdisp,idisp] = disp_bcc_hfm(hkl(1,:),hkl(2,:),hkl(3,:),par);
    en0 = wdisp{1};
    en0sq =en0.^2;
    g_sq = gamma*gamma;
    sq = sqrt((en0sq-g_sq).*en0sq+g_sq*g_sq);
    root_p = en0sq-2*g_sq+2*sq;
    hp{i} = sqrt(3)*16*290.6*(4/pi)*abs(gamma.*en0).*idisp{1}.*...
        bose_times_eps(root_p/3,T)./(sqrt(root_p).*(en0sq+g_sq+sq).*(en0sq-g_sq+sq));
    %linD(i) = IX_dataset_1d(x,wdisp{1});
    %pl(linD(i));
    %keep_figure;
end

xxt=cat(2,xp{:});
hpt = cat(2,hp{:});
plot(xxt,hpt);
end

function hkl = hkl_path_from_proj(Np,rlu,np)
%hkl_path_from_proj -- Generate hkl path along 
%
% 
u0 = rlu(:,np-1);
u1 = rlu(:,np);
vec = u1-u0;
vec = vec(:);
dVec = vec/(Np-1);
ii = 0:Np-1;
hkl = u0(:) + dVec*ii; 
% hkl = zeros(3,Np);
% for i=1:Np
%     hkl(:,i) = u0+dVec*(i-1);
% end

end