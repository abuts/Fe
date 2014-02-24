data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei787.sqw';

no_chkpnts='True';
pause on

Imax = 0.2;

dE=5;
dk=0.1;
peP1 = parWithCorrections([-0.225,-0.175,0,0.275,0.375;
                         102,47,0,62.5,217]);
peP1.cut_direction=[1,0,0];
peP1.dE =dE;
peP1.dk =dk;

peP2 = parWithCorrections([-0.375,-0.225,0,0.175,0.325;
                         167.5,42.5,0,37.5,172.5]);
peP2.cut_direction=[0,1,0];
peP2.dE =dE;
peP2.dk =dk;

peP3 = parWithCorrections([-0.375,-0.175,0,0.175,0.325;
                         167.5,42.5,0,47.5,172.5]);
peP3.cut_direction=[0,0,1];
peP3.dE =dE;
peP3.dk =dk;



repP={peP3,peP2,peP1};

colors={'r','g','blue','c','m','k'};
lines ={'ro','gs','bx','cd','mo','kd'};

n_cuts =numel(repP);
fit_par= cell(n_cuts,1);
SWX = cell(n_cuts,1);
SWY   = cell(n_cuts,1);
SWErr = cell(n_cuts,1);
ISW1  = cell(n_cuts,1);
ISW2  = cell(n_cuts,1);
for i=1:numel(repP)
    rp1=repP{i}; 
    [fit_par{i},SWX{i},SWY{i},SWErr{i},ISW1{i},ISW2{i}]=fit_1SpinWave(data_source,[1,-1,0],rp1,colors{i},lines{i},no_chkpnts,Imax);
end

I_max = -1.e+64;
for i=1:n_cuts
    I_max = max([ISW1{i}.signal;ISW2{i}.signal;I_max]);
end
disp(['Max Intensity: ', num2str(I_max)]);

% for i=1:n_cuts
%     ISW1{i} = ISW1{i}/I_max;
%     ISW2{i} = ISW2{i}/I_max;
% end

bestE800k1m10=struct('par1',fit_par{1},'br1',ISW1{1},'br2',ISW2{1});
save('ei200_uvw100at1m10best','bestE800k1m10');

acolor(colors{1})
aline('-')
figH=dd(ISW1{1});
set(figH,'Name','Spin wave intensity along <1,0,0> directions around lattice point [1,-1,0]')
pd(ISW2{1})

for i=2:n_cuts
    acolor(colors{i})
    pd(ISW1{i})
    pd(ISW2{i})
end
ly 0 200;
lx 40 160;


% all cuts
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
figure('Name','Spin Wave Dispersion in <1,0,0> directions around lattice point [1,-1,0] ');


xxi=-0.38:0.01:0.38;
for i=1:n_cuts
    plot(SWX{i},SWY{i},lines{i});
    hold on
    plot(SWErr{i}(1,:),SWErr{i}(2,:),['-',colors{i}]);
    yyi=fitpar(xxi,fit_par{i}.p);
    plot(xxi,yyi,colors{i});
end
lx -0.5 0.5

D=0;
for i=1:n_cuts
    par = fit_par{i};
    D=D+par.p(3);
end

disp([' D of SQ avrg=',num2str(D)])
