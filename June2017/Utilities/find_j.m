qhl = -0.37:0.001:-0.1471;
qh =  0.1471:0.001:0.37;
% qhl = -0.5:0.001:-0.01;
% qh   = 0.01:0.001:0.5;
%tp = [1,0,60,10,-5,-5,5];
tp = [1,0,60,10,-5,0,0];
qh = [qhl,qh];
qk = zeros(size(qh));
ql = zeros(size(qh));
e = disp_bcc_parameterized(qh,qk,ql,[1,0]);
%e = disp_bcc_hfm(qh,qk,ql,tp);
e = e{1};
%

[pc4,S] = polyfit(qh,e,4);
[eis,Delta] = polyval(pc4,qh,S);
disp([' Delta: ',num2str(sum(Delta)/numel(Delta))]);
plot(qh,e,'r');
plot(qh,e,'r',qh,eis,'g');

disp('**************************************')
disp('dir 100')

fprintf('DH: %f; +  %f*x^2 + %f*x^4 \n',pc4(5),pc4(3),pc4(1));
fprintf('ERR: %f*x + %f*x^3 \n',pc4(4),pc4(2));
pc100 = [pc4(3),pc4(1)];

qh12 = qh/sqrt(2);
qk12 = qh/sqrt(2);
e = disp_bcc_parameterized(qh12,qh12,ql,[1,0]);
%e = disp_bcc_hfm(qh12,qk12,ql,tp);

e = e{1};
[pc4,S] = polyfit(qh,e,4);
[eis,Delta] = polyval(pc4,qh,S);
disp([' Delta: ',num2str(sum(Delta)/numel(Delta))]);

plot(qh,e,'r');
plot(qh,e,'r',qh,eis,'g');

disp('dir 110')
fprintf('DH: %f; +  %f*x^2 + %f*x^4 \n',pc4(5),pc4(3),pc4(1));
fprintf('ERR: %f*x + %f*x^3 \n',pc4(4),pc4(2));
pc110 = [pc4(3),pc4(1)];

qh13 = qh/sqrt(3);
qk13 = qh/sqrt(3);
ql13 = qh/sqrt(3);

e = disp_bcc_parameterized(qh13,qh13,qh13,[1,0]);
%e = disp_bcc_hfm(qh13,qk13,ql13,tp);

e= e{1};
[pc4,S] = polyfit(qh,e,4);
[eis,Delta] = polyval(pc4,qh,S);
disp([' Delta: ',num2str(sum(Delta)/numel(Delta))]);

plot(qh,e,'r');
plot(qh,e,'r',qh,eis,'g');

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
disp(J);
% 
% function res = poly_n(x,pc)
% res = pc(1)*ones(size(x));
% for i=2:numel(pc)
%     res = res.*x + pc(i);
% end
% end
