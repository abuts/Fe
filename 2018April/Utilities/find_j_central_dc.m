q_max = 0.37;
q_min = 0.15;
qh =  q_min:0.01:q_max;
qhl =  -q_max:0.01:-q_min;
qh = [qhl,qh];
qk = zeros(size(qh));
ql = zeros(size(qh));
dec_zero = 0.0; % the Q point where the derivatives, stored in the file below are calculated

self_test = false;
tp = [1,0,  63.7446   -5.4095   -8.7849,0,0];
%tp = [1,0,  20.1511   5.        5,0,0];
%tp = [1,0,437.0574  129.2188  -78.8266,0,0];
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


A =  csvread('DispersionExpandTo4.csv');
qh_p = qh-dec_zero;

ed = disp_bcc_hfm(qh,qk,ql,tp);
ed = ed{1};
tfe = 8*tp(3)*(1-cos(pi*qh))+4*tp(4)*sin(pi*qh).^2 + 8*tp(5)*(1-cos(2*pi*qh));
JC = A(1:5,:)*tp(3:5)';
tfeD1=JC(1)+ qh_p.*(JC(2)+ qh_p.*JC(3)+...
    qh_p.*(JC(4)+qh_p.*(JC(5))));
%plot(qh,ed,'r',qh,tfe,'b.',qh,tfeD1,'g.');

e = disp_bcc_parameterized(qh,qk,ql,[1,0,1]);
e = e{1};
%
if self_test
    [pc4,S] = polyfit(qh_p,ed,4);
else
    [pc4,S] = polyfit(qh_p,e,4);
end
[eis,Delta] = polyval(pc4,qh_p,S);
disp([' Delta: ',num2str(sum(Delta)/numel(Delta))]);
disp('**************************************')
disp('dir 100')
pc100 = flipud(pc4')';

if self_test
    plot(qh,ed,'r',qh,eis,'g--',qh,tfe,'b:',qh,tfeD1,'k.');
else
    plot(qh,e,'r',qh,eis,'g--');
end

hold on
J100 = A(1:5,:)\pc100';
fprintf('100: J0: %f + J1:%f +  J2:%f\n',J100);

fprintf('REAL fit: %f + %f*x +  %f*x^2 + %f*x^3 + %f*x^4 \n',pc100);
fprintf('TEST fit: %f + %f*x +  %f*x^2 + %f*x^3 + %f*x^4 \n',JC);



qh12 = qh/sqrt(2);
ed = disp_bcc_hfm(qh12,qh12,ql,tp);
ed = ed{1};
tfe = 8*tp(3)*(1-cos(pi/sqrt(2)*qh).^2)+8*tp(4)*sin(pi/sqrt(2)*qh).^2 + 4*tp(5)*(3-cos(2*pi/sqrt(2)*qh).^2-2*cos(2*pi/sqrt(2)*qh));
JC = A(6:10,:)*tp(3:5)';
tfeD1=JC(1)+ qh_p.*(JC(2)+ qh_p.*JC(3)+...
    qh_p.*(JC(4)+qh_p.*(JC(5))));

%plot(qh,ed,'r',qh,tfe,'b.',qh,tfeD1,'g.');



e = disp_bcc_parameterized(qh12,qh12,ql,[1,0,2]);

e = e{1};
if self_test
    [pc4,S] = polyfit(qh_p,ed,4);
else
    [pc4,S] = polyfit(qh_p,e,4);
end

[eis,Delta] = polyval(pc4,qh_p,S);
disp([' Delta: ',num2str(sum(Delta)/numel(Delta))]);
disp('dir 110')
pc110 = flipud(pc4')';
if self_test
    plot(qh,ed,'r',qh,eis,'g--',qh,tfe,'b:',qh,tfeD1,'k.');
else
    plot(qh,e,'r',qh,eis,'g--');
end
J110 = A(1:10,:)\[pc100,pc110]';
fprintf('110: J0: %f + J1:%f +  J2:%f\n',J110);

fprintf('REAL fit: %f + %f*x +  %f*x^2 + %f*x^3 + %f*x^4 \n',pc110);
fprintf('TEST fit: %f + %f*x +  %f*x^2 + %f*x^3 + %f*x^4 \n',JC);



qh13 = qh/sqrt(3);
qk13 = qh/sqrt(3);
ql13 = qh/sqrt(3);


ed = disp_bcc_hfm(qh13,qk13,ql13,tp);
ed = ed{1};
tfe = 8*tp(3)*(1-cos(pi/sqrt(3)*qh).^3)+12*tp(4)*sin(pi/sqrt(3)*qh).^2 + 12*tp(5)*(1-cos(2*pi/sqrt(3)*qh).^2);
JC = A(11:15,:)*tp(3:5)';
tfeD1=JC(1)+ qh_p.*(JC(2)+ qh_p.*JC(3)+...
    qh_p.*(JC(4)+qh_p.*(JC(5))));

%plot(qh,ed,'r',qh,tfe,'b.',qh,tfeD1,'g.');



e = disp_bcc_parameterized(qh13,qh13,qh13,[1,0,3]);
e= e{1};
if self_test
    [pc4,S] = polyfit(qh_p,ed,4);
else
    [pc4,S] = polyfit(qh_p,e,4);
end

[eis,Delta] = polyval(pc4,qh_p,S);
disp([' Delta: ',num2str(sum(Delta)/numel(Delta))]);
disp('dir 111')
pc111 = flipud(pc4')';

if self_test
    plot(qh,ed,'r',qh,eis,'g--',qh,tfe,'b:',qh,tfeD1,'k.');
else
    plot(qh,e,'r',qh,eis,'g--');
    
end

lx(q_min,q_max);
J111 = A(11:15,:)\pc111';
fprintf('111: J0: %f + J1:%f +  J2:%f\n',J111);
fprintf('REAL fit: %f + %f*x +  %f*x^2 + %f*x^3 + %f*x^4 \n',pc111);
fprintf('TEST fit: %f + %f*x +  %f*x^2 + %f*x^3 + %f*x^4 \n',JC);


disp('**************************************')

%L =  csvread('GeninvTo4.csv'); % check the inverted matrix before
%comparing with A
%A = [eye(3);eye(3);eye(3);eye(3);eye(3)];
% inv(A)
R = [pc100,pc110,pc111]';
J = A\R;
%J = L*R;
disp(J');
%ts = A*J
%
tp = [1,0, J(:)',0,0];
ed = disp_bcc_hfm(qh,qk,ql,tp);
plot(qh,ed{1},'b--');
ed = disp_bcc_hfm(qh12,qh12,ql,tp);
plot(qh,ed{1},'b--');
ed = disp_bcc_hfm(qh13,qh13,qh13,tp);
plot(qh,ed{1},'b--');


hold off
