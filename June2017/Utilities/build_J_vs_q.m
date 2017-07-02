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

e_min = min(x);
e_max = max(x);
J_min = min(s);
J_max = max(s);

q= 0.01:0.01:0.99;
JvsQ100 = zeros(size(q));
JvsQ110 = zeros(size(q));
JvsQ111 = zeros(size(q));

for i=1:numel(q)
    JvsQ100(i) = 0.125*fzero(@(e)(j_vs_e100(e,q(i),x,s,e_min,J_min,e_max,J_max)),0)/(1-cos(pi*q(i)));
    JvsQ110(i) = 0.125*fzero(@(e)(j_vs_e110(e,q(i),x,s,e_min,J_min,e_max,J_max)),0)/(1-cos(pi/sqrt(2)*q(i)).^2);
    JvsQ111(i) = 0.125*fzero(@(e)(j_vs_e111(e,q(i),x,s,e_min,J_min,e_max,J_max)),0)/(1-cos(pi/sqrt(3)*q(i)).^3);
end
q_sq = q.*q;

qi_min = acos(1-e_min/(8*J_min))/pi;
qi_max = acos(1-e_max/(8*J_max))/pi;
JvsQ = cell(3,1);
JvsQ{1}= JvsQ100;
JvsQ{2} = JvsQ110;
JvsQ{3} = JvsQ111;
plot(q_sq,JvsQ{1},'r',q_sq,JvsQ{2},'g',q_sq,JvsQ{3},'b');


save('J_vs_q','qi_min','qi_max','J_min','J_max','q_sq','JvsQ');



function val = j_vs_e100(en,q,base_e,base_j,e_min,J_min,e_max,J_max)


if en<e_min
    Je = J_min;
elseif en>e_max
    Je = J_max;
else
    Je = interp1(base_e,base_j,en);
end
val = 8*Je*(1-cos(pi*q))-en;
end

function val = j_vs_e110(en,q,base_e,base_j,e_min,J_min,e_max,J_max)


if en<e_min
    Je = J_min;
elseif en>e_max
    Je = J_max;
else
    Je = interp1(base_e,base_j,en);
end
val = 8*Je*(1-cos(pi/sqrt(2)*q).^2)-en;
end
function val = j_vs_e111(en,q,base_e,base_j,e_min,J_min,e_max,J_max)


if en<e_min
    Je = J_min;
elseif en>e_max
    Je = J_max;
else
    Je = interp1(base_e,base_j,en);
end
val = 8*Je*(1-cos(pi/sqrt(3)*q).^3)-en;
end




