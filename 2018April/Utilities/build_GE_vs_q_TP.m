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
J = [s_tot1',s_tot2',s_tot3'];
err = [e_tot1',e_tot2',e_tot3'];
se = J+err;
errorbar(x,J,err);

e_min = min(x);
e_max = max(x);
J_min = min(J);
J_max = max(J);

q100= zeros(size(J));
q110= zeros(size(J));
q111= zeros(size(J));
JvsQ100 = zeros(size(q100));
JvsQ110 = zeros(size(q100));
JvsQ111 = zeros(size(q100));
JvsQ100_e = zeros(size(q100));
JvsQ110_e = zeros(size(q100));
JvsQ111_e = zeros(size(q100));
disp_d100 = zeros(numel(q100),2);
disp_d110 = zeros(numel(q100),2);
disp_d111 = zeros(numel(q100),2);

ld = load('s_g_vs_eEi400.mat');
g100 = [ld.g_of_e(1).x;ld.g_of_e(1).signal'];
g110 = [ld.g_of_e(2).x;ld.g_of_e(2).signal'];
g111 = [ld.g_of_e(3).x;ld.g_of_e(3).signal'];

for i=1:numel(q100)
    % this gived dispersion e (q);
    q100(i) = acos((1- x(i)/(8*J(i))))/pi;
    q110(i) = acos(sqrt((1- x(i)/(8*J(i)))))*sqrt(2)/pi;
    q111(i) = acos(((1- x(i)/(8*J(i))))^(1/3))*sqrt(3)/pi;        
    E_vs_q100 = x(i);
    Err_vs_q100 = fzero(@(e)(j_vs_e100(e,q100(i),x,se,e_min,J_min,e_max,J_max)),0);
    JvsQ100_e(i) = abs(Err_vs_q100 -E_vs_q100);
    % and this strips it to J(q);
    JvsQ100(i) = 0.125*E_vs_q100/(1-cos(pi*q100(i)));
    disp_d100(i,1) =     E_vs_q100 ;
%     disp_d100(i,2) =     err(i);
    
    
    E_vs_q110 = x(i);
    Err_vs_q110 = fzero(@(e)(j_vs_e110(e,q110(i),x,se,e_min,J_min,e_max,J_max)),0);    
    JvsQ110_e(i) = abs(Err_vs_q110-E_vs_q110);
    JvsQ110(i) = 0.125*E_vs_q110/(1-cos(pi/sqrt(2)*q110(i)).^2);
    disp_d110(i,1) =     E_vs_q110 ;
%     disp_d110(i,2) =     err(i);
    
    
    E_vs_q111 =  x(i);
    Err_vs_q111 = fzero(@(e)(j_vs_e111(e,q111(i),x,se,e_min,J_min,e_max,J_max)),0);    
    JvsQ111_e(i) = abs(Err_vs_q111-E_vs_q111);
    
    disp_d111(i,1) =     E_vs_q111 ;    
%     disp_d111(i,2) =     err(i) ;
    
    
    JvsQ111(i) = 0.125*E_vs_q111/(1-cos(pi/sqrt(3)*q(i)).^3);
end
disp_d100(1,isnan(disp_d100(1,:)) )= 0;

disp_d100(2,:) = interp1(g100(1,:),g100(2,:),disp_d100(1,:));
disp_d110(2,:) = interp1(g110(1,:),g110(2,:),disp_d110(1,:));
disp_d111(2,:) = interp1(g111(1,:),g111(2,:),disp_d111(1,:));


% q_sq = q.*q;
% 
% qi_min = acos(1-e_min/(8*J_min))/pi;
% qi_max = acos(1-e_max/(8*J_max))/pi;
% JvsQ = cell(3,1);
% JvsQ_err = cell(3,1);
% JvsQ{1}= JvsQ100;
% JvsQ{2} = JvsQ110;
% JvsQ{3} = JvsQ111;
% EvsQ_err{1} = JvsQ100_e;
% EvsQ_err{2} = JvsQ110_e;
% EvsQ_err{3} = JvsQ111_e;
% plot(q100,JvsQ{1},'r',q110,JvsQ{2},'g',q111,JvsQ{3},'b');
% hold on
% errorbar(q100,JvsQ{1},EvsQ_err{1},'r')
% errorbar(q110,JvsQ{2},EvsQ_err{2},'g')
% errorbar(q111,JvsQ{3},EvsQ_err{3},'b')
%hold off

%save('J_vs_q','qi_min','qi_max','J_min','J_max','q_sq','JvsQ','EvsQ_err');
res = struct();
res.disp100 = IX_dataset_1d(q100,disp_d100(:,1),disp_d100(:,2));
res.disp110 = IX_dataset_1d(q110,disp_d110(:,1),disp_d110(:,2));
res.disp111 = IX_dataset_1d(q111,disp_d111(:,1),disp_d111(:,2));
acolor('r')
dd(res.disp100);
acolor('g');
pd(res.disp110);
acolor('b');
pd(res.disp111);

%save('En_vs_qTP','-struct','res');


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



