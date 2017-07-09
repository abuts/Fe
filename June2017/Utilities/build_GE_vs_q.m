ld = load('J_vs_E.mat');

x2     = ld.fj200.x;
f2     = ld.fj200.signal;
f2_err = ld.fj200.error;


x4 = ld.fj400.x;
f4 = ld.fj400.signal;
f4_err = ld.fj400.error;
e_min_s = 45;
e_max_s = 125;

% first subrange: take from ei200
ir2_min = find(x2==e_min_s);
ir2_max = find(x2==e_max_s);
x_tot1 = x2(1:ir2_min);
s_tot1 = f2(1:ir2_min);
e_tot1 = f2_err(1:1:ir2_min);

% second subrange: take half from ei200, half from ei400
s_par2 =f2(ir2_min+1:ir2_max);

ir4_min = find(x4==e_min_s);
ir4_max = find(x4==e_max_s);
s_par4 =f4(ir4_min+1:ir4_max);

s_tot2 = 0.5*(s_par2 + s_par4);
x_tot2 = x4(ir4_min+1:ir4_max);
e_tot2 = f4_err(ir4_min+1:ir4_max);

% third subrange: take data from ei400
e_max_t = 180;
ir4t_max = find(x4==e_max_t);
s_tot3 = f4(ir4_max+1:ir4t_max);
x_tot3 = x4(ir4_max+1:ir4t_max);
e_tot3 = f4_err(ir4_max+1:ir4t_max);

x = [x_tot1,x_tot2,x_tot3];
s = [s_tot1',s_tot2',s_tot3'];
err = [e_tot1',e_tot2',e_tot3'];
se = s+err;
errorbar(x,s,err);
ld = load('s_g_vs_eEi400.mat');
g100 = [ld.g_of_e(1).x;ld.g_of_e(1).signal'];
g110 = [ld.g_of_e(2).x;ld.g_of_e(2).signal'];
g111 = [ld.g_of_e(3).x;ld.g_of_e(3).signal'];

e_min = min(x);
e_max = max(x);
J_min = min(s);
J_max = max(s);

q= 0.1:0.01:0.5;
JvsQ100 = zeros(size(q));
JvsQ110 = zeros(size(q));
JvsQ111 = zeros(size(q));
JvsQ100_e = zeros(size(q));
JvsQ110_e = zeros(size(q));
JvsQ111_e = zeros(size(q));
disp_d100 = zeros(2,numel(q));
disp_d110 = zeros(2,numel(q));
disp_d111 = zeros(2,numel(q));
for i=1:numel(q)
    % this gived dispersion e (q);
    E_vs_q100 = fzero(@(e)(j_vs_e100(e,q(i),x,s,e_min,J_min,e_max,J_max)),0);
    % and this strips it to J(q);
    JvsQ100(i) = 0.125*E_vs_q100/(1-cos(pi*q(i)));
    disp_d100(1,i) =     E_vs_q100 ;
    
    
    E_vs_q110 = fzero(@(e)(j_vs_e110(e,q(i),x,s,e_min,J_min,e_max,J_max)),0);
    JvsQ110(i) = 0.125*E_vs_q110/(1-cos(pi/sqrt(2)*q(i)).^2);
    disp_d110(1,i) =     E_vs_q110 ;
    %     disp_d110(i,2) =     JvsQ110_e(i);
    
    
    E_vs_q111 =  fzero(@(e)(j_vs_e111(e,q(i),x,s,e_min,J_min,e_max,J_max)),0);
    JvsQ111(i) = 0.125*E_vs_q111/(1-cos(pi/sqrt(3)*q(i)).^3);
    disp_d111(1,i) =   E_vs_q111 ;
    
end
disp_d100(2,:) = interp1(g100(1,:),g100(2,:),disp_d100(1,:));
disp_d110(2,:) = interp1(g110(1,:),g110(2,:),disp_d110(1,:));
disp_d111(2,:) = interp1(g111(1,:),g111(2,:),disp_d111(1,:));



q_sq = q.*q;

qi_min = acos(1-e_min/(8*J_min))/pi;
qi_max = acos(1-e_max/(8*J_max))/pi;
JvsQ = cell(3,1);
JvsQ_err = cell(3,1);
JvsQ{1}= JvsQ100;
JvsQ{2} = JvsQ110;
JvsQ{3} = JvsQ111;
% EvsQ_err{1} = JvsQ100_e;
% EvsQ_err{2} = JvsQ110_e;
% EvsQ_err{3} = JvsQ111_e;
% plot(q_sq,JvsQ{1},'r',q_sq,JvsQ{2},'g',q_sq,JvsQ{3},'b');
% hold on
% errorbar(q,disp_d100{1,1},EvsQ_err{1},'r')
% errorbar(q,JvsQ{2},EvsQ_err{2},'g')
% errorbar(q,JvsQ{3},EvsQ_err{3},'b')
%hold off

res = struct();
res.disp100 = IX_dataset_1d(q,disp_d100(1,:),disp_d100(2,:));
res.disp110 = IX_dataset_1d(q,disp_d110(1,:),disp_d110(2,:));
res.disp111 = IX_dataset_1d(q,disp_d111(1,:),disp_d111(2,:));
acolor('r')
dd(res.disp100);
acolor('g');
pd(res.disp110);
acolor('b');
pd(res.disp111);

% save('En_vs_q','-struct','res');


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



