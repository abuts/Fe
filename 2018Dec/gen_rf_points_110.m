function bp=gen_rf_points_110(d,bragg_list)
% build 
np = size(bragg_list,1);
bp = zeros(4*np,2);
for i=1:np
    bg0 = bragg_list(i,:);
    bp(4*(i-1)+1,1) = bg0(1)-d;
    bp(4*(i-1)+1,2) = bg0(2)-d;
    bp(4*(i-1)+2,1) = bg0(1)+d;
    bp(4*(i-1)+2,2) = bg0(2)+d;
    bp(4*(i-1)+3,1) = bg0(1)+d;
    bp(4*(i-1)+3,2) = bg0(2)-d;
    bp(4*(i-1)+4,1) = bg0(1)-d;
    bp(4*(i-1)+4,2) = bg0(2)+d;
end
