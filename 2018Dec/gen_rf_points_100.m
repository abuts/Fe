function bp=gen_rf_points_100(d,bragg_list)

np = size(bragg_list,2);
bp = zeros(2,4*np);
for i=1:np
    bg0 = bragg_list(:,i);
    bp(1,4*(i-1)+1) = bg0(1)-d;
    bp(2,4*(i-1)+1) = bg0(2);
    bp(1,4*(i-1)+2) = bg0(1)+d;
    bp(2,4*(i-1)+2) = bg0(2);
    bp(1,4*(i-1)+3) = bg0(1);
    bp(2,4*(i-1)+3) = bg0(2)-d;
    bp(1,4*(i-1)+4) = bg0(1);
    bp(2,4*(i-1)+4) = bg0(2)+d;
end
