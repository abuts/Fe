q_max = 0.37;
qhl = -q_max:0.01:-0.1471;
qh =  0.1471:0.01:q_max;
qh = [qhl,qh];
qk = zeros(size(qh));
ql = zeros(size(qh));

self_test = false;
tp = [1,0,  63.1511   -3.2433   -9.3387,0,0];
% tp = [1,0,51.5853,   -2.8766,   -6.0617,0,0];

ld = load('En_vs_qTP');
data0 = repmat(IX_dataset_1d,3,1);
data0(1) = ld.disp100;
data0(2) = ld.disp110;
data0(3) = ld.disp111;
%data = repmat(struct('x',[],'y',[],'e',[]),3,1);
% [e,err] = disp_bcc_parameterized(qh,qk,ql,[1,0,1]);
% data0(1)= IX_dataset_1d(qh,e{1},err{1});
% data(1).x = qh; 
% data(1).y = e{1};
% data(1).e = err{1};
% qh12 = qh/sqrt(2);
% [e,err] = disp_bcc_parameterized(qh12,qh12,ql,[1,0,2]);
% data0(2) = IX_dataset_1d(qh,e{1},err{1});
% data(2).x = qh; 
% data(2).y = e{1};
% data(2).e = err{1};
% 
% qh13 = qh/sqrt(3);
% [e,err] = disp_bcc_parameterized(qh13,qh13,qh13,[1,0,3]);
% data0(3) = IX_dataset_1d(qh,e{1},err{1});
% data(3).x = qh; 
% data(3).y = e{1};
% data(3).e = err{1};
aline('-')
acolor('r','g','b');
dl(data0);
fun = {@disp_bcc_hfm_red1,@disp_bcc_hfm_red2,@disp_bcc_hfm_red3};


kk = multifit2(data0);
kk = kk.set_local_foreground(true);
kk = kk.set_fun(fun,tp,[0,0,1,1,1,0,0]);

binds = {{3,[3,2],1},{4,[4,2],1},{5,[5,2],1}};
kk = kk.set_bind(binds{:});
kk = kk.set_options('listing',2,'fit_control_parameters',[1.e-2;60;1.e-3]);

[fd,fitpar] = kk.fit;
disp('fitpar:')
disp(fitpar.p{1})
% data0(1) = IX_dataset_1d(fd(1).x,fd(1).y,fd(1).e);
% data0(2) = IX_dataset_1d(fd(2).x,fd(2).y,fd(2).e);
% data0(3) = IX_dataset_1d(fd(3).x,fd(3).y,fd(3).e);
aline('--')
pl(fd);
%lx(0.14,q_max);

%

function res = disp_bcc_hfm_red1(qh,par)

par= [par(:);1];
res = disp_bcc_hfm_red(qh,par);
end
function res = disp_bcc_hfm_red2(qh,par)

par= [par(:);2];
res = disp_bcc_hfm_red(qh,par);
end

function res = disp_bcc_hfm_red3(qh,par)

par= [par(:);3];
res = disp_bcc_hfm_red(qh,par);
end

