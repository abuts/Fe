q_max = 0.37;
qhl = -q_max:0.01:-0.1471;
qh =  0.1471:0.001:q_max;
qh = [qhl,qh];
qk = zeros(size(qh));
ql = zeros(size(qh));

self_test = false;
tp = [1,0,  63.1511   -3.2433   -9.3387,0,0];
% tp = [1,0,51.5853,   -2.8766,   -6.0617,0,0];
% tp = [1,0,44.2426,   -2.3311,   -4.0033,0,0];
% tp = [1,0,39.2538,   -0.9658,   -2.8961,0,0];
% tp = [1,0, 35.8751,    0.4770,   -2.2991,0,0];
% tp = [1,0, 33.5914,    1.7217,   -1.97600,0,0];
% tp = [1,0, 32.0492,    2.7014,   -1.8004,0,0];
% tp = [1,0,   31.0072,    3.4336,   -1.7043,0,0];
% tp = [1,0,   30.3019,    3.9632,   -1.6512,0,0];
% tp = [1,0, 29.8228,    4.3377,   -1.6215,0,0];
% tp = [1,0, 29.4953,    4.5982,   -1.6046,0,0];
% tp = [1,0, 29.2693,    4.7769,   -1.5946,0,0];
% tp = [1,0, 29.1113,    4.8982,   -1.5885,0,0];
% tp = [1,0, 28.9986,    4.9795,   -1.5845,0,0];
% tp = [1,0, 28.9163,    5.0334,   -1.5817,0,0];
% tp = [1,0, 28.8542,    5.0686,   -1.5796,0,0];
% tp = [1,0, 28.8056,    5.0910,   -1.5779,0,0];
% tp = [1,0,28.7660,    5.1048,   -1.5764,0,0];
% tp = [1,0,28.7325    5.1128   -1.5750,0,0];
%tp = [1,0,28.7030,    5.1169,   -1.5737,0,0];
%tp = [1,0,24.7030,    5.1169,   -1.5737,0,0];



ed = disp_bcc_hfm(qh,qk,ql,tp);
ed = ed{1};
e = disp_bcc_parameterized(qh,qk,ql,[1,0,1]);
e = e{1};
%

[pc4,S] = polyfit(qh,e,4);
[eis,Delta] = polyval(pc4,qh,S);
disp([' Delta: ',num2str(sum(Delta)/numel(Delta))]);
plot(qh,e,'r',qh,eis,'g--',qh,ed,'b.');
hold on
disp('**************************************')
disp('dir 100')

fprintf('DH: %f; +  %f*x^2 + %f*x^4 \n',pc4(5),pc4(3),pc4(1));
fprintf('ERR: %f*x + %f*x^3 \n',pc4(4),pc4(2));
pc100 = [pc4(3),pc4(1)];

qh12 = qh/sqrt(2);
qk12 = qh/sqrt(2);
ed = disp_bcc_hfm(qh12,qk12,ql,tp);
ed = ed{1};
e = disp_bcc_parameterized(qh12,qh12,ql,[1,0,2]);

e = e{1};
[pc4,S] = polyfit(qh,e,4);
[eis,Delta] = polyval(pc4,qh,S);
disp([' Delta: ',num2str(sum(Delta)/numel(Delta))]);

plot(qh,e,'r',qh,eis,'g--',qh,ed,'b:');

disp('dir 110')
fprintf('DH: %f; +  %f*x^2 + %f*x^4 \n',pc4(5),pc4(3),pc4(1));
fprintf('ERR: %f*x + %f*x^3 \n',pc4(4),pc4(2));
pc110 = [pc4(3),pc4(1)];

qh13 = qh/sqrt(3);
qk13 = qh/sqrt(3);
ql13 = qh/sqrt(3);


ed = disp_bcc_hfm(qh13,qk13,ql13,tp);
ed = ed{1};
e = disp_bcc_parameterized(qh13,qh13,qh13,[1,0,3]);
e= e{1};
[pc4,S] = polyfit(qh,e,4);
[eis,Delta] = polyval(pc4,qh,S);
disp([' Delta: ',num2str(sum(Delta)/numel(Delta))]);

plot(qh,e,'r',qh,eis,'g--',qh,ed,'b.');
lx(0.14,q_max);
hold off
disp('dir 111')
fprintf('DH: %f; +  %f*x^2 + %f*x^4 \n',pc4(5),pc4(3),pc4(1));
fprintf('ERR: %f*x + %f*x^3 \n',pc4(4),pc4(2));
pc111 = [pc4(3),pc4(1)];

disp('**************************************')

% % ei = poly_n(qh,pc6);
% %
% % acolor('g');
% % plot(qh,ei);
% % hold off;
%
% ?^2	?^2	4*?^2
% -?^4/12	-?^4/3	-4*?^4/3
% ?^2	?^2	4*?^2
% -?^4/6	-?^4/6	-5*?^4/3
% ?^2	?^2	4*?^2
% -7*?^4/36	-?^4/9	-16*?^4/9
A = 4*pi^2*[1,1,4;...
    -pi^2/12,-pi^2/3, -4*pi^2/3;...
    1,1,4;
    -pi^2/6	-pi^2/6	-5*pi^2/3;...
    1,1,4;
    -7*pi^2/36	-pi^2/9	-16*pi^2/9];
% inv(A)
R = [pc100,pc110,pc111]';
J = A\R;
disp(J');
%
% function res = poly_n(x,pc)
% res = pc(1)*ones(size(x));
% for i=2:numel(pc)
%     res = res.*x + pc(i);
% end
% end
