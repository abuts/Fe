ld = load('J_vs_E.mat');

x2 = ld.jf200.x;
f2 = ld.jf200.signal;
e_min = x2(1);
J_min = f2(1);

x4 = ld.jf400.x;
f4 = ld.jf400.signal;
e_min_s = 45;
e_max_s = 125;

% first subrange: take from ei200
ir2_min = find(x2==e_min_s);
ir2_max = find(x2==e_max_s);
x_tot1 = x2(1:ir2_min);
s_tot1 = f2(1:ir2_min);

% second subrange: take half from ei200, half from ei400
s_par2 =f2(ir2_min+1:ir2_max);

ir4_min = find(x4==e_min_s);
ir4_max = find(x4==e_max_s);
s_par4 =f4(ir4_min+1:ir4_max);

s_tot2 = 0.5*(s_par2 + s_par4);
x_tot2 = x4(ir4_min+1:ir4_max);

% third subrange: take data from ei400
e_max_t = 180;
ir4t_max = find(x4==e_max_t);
s_tot3 = f4(ir4_max+1:ir4t_max);
x_tot3 = x4(ir4_max+1:ir4t_max);

x = [x_tot1,x_tot2,x_tot3];
s = [s_tot1',s_tot2',s_tot3'];
plot(x,s);

x_min = min(x);
x_max = max(x);
J_min = min(s);
J_max = max(s);

q= 0.01:0.01:0.99;
JvsQ = zeros(size(q));
for i=1:numel(q)
    JvsQ(i) = 0.125*fzero(@(e)(j_vs_e(e,q(i),x,s,x_min,J_min,x_max,J_max)),0)/(1-cos(pi*q(i)));
end
q_sq = q.*q;

plot(q_sq,JvsQ);
save('J_vs_q','q_sq','JvsQ');



function val = j_vs_e(x,q,base_e,base_j,x_min,J_min,x_max,J_max)


if x<x_min
    Je = J_min;
elseif x>x_max
    Je = J_max;
else
    Je = interp1(base_e,base_j,x);
end
val = 8*Je*(1-cos(pi*q))-x;
end




