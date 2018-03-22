data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei787.sqw';

no_chkpnts='True';
pause on

Imax = 0.2;

dE=5;
dk=0.1;
peP1 = parWithCorrections([-0.325,-0.075,0,0.125,0.425;
                         137,15,0,15,155]);
peP1.cut_direction=[1,1,1];
peP1.dE =dE;
peP1.dk =dk;

peP2 = parWithCorrections([-0.3125,-0.0875,0,0.1375,0.3875;
                         131,15,0,15,153]);
peP2.cut_direction=[1,1,-1];
peP2.dE =dE;
peP2.dk =dk;

peP3 = parWithCorrections([-0.3375,-0.1125,0,0.1375,0.4125;
                         131,15,0,13,151]);
peP3.cut_direction=[1,-1,-1];
peP3.dE =dE;
peP3.dk =dk;

peP4 = parWithCorrections([-0.3635,-0.1375,0,0.1125,0.3375;
                         151,15,0,11,131]);
peP4.cut_direction=[1,-1,1];
peP4.dE =dE;
peP4.dk =dk;




repP={peP4,peP3,peP1,peP2};

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
    [fit_par{i},SWX{i},SWY{i},SWErr{i},ISW1{i},ISW2{i}]=fit_1SpinWave(data_source,[1,1,0],rp1,colors{i},lines{i},no_chkpnts,Imax);
end

I_max = -1.e+64;
for i=1:n_cuts
    I_max = max([ISW1{i}.signal;ISW2{i}.signal;I_max]);
end
disp(['Max Intensity: ', num2str(I_max)]);

for i=1:n_cuts
    ISW1{i} = ISW1{i}/I_max;
    ISW2{i} = ISW2{i}/I_max;
end


acolor(colors{1})
aline('-')
figH=dd(ISW1{1});
set(figH,'Name','Spin wave intensity along <1,0,0> directions around lattice point [2,0,0]')
pd(ISW2{1})

for i=2:n_cuts
    acolor(colors{i})
    pd(ISW1{i})
    pd(ISW2{i})
end
ly 0 1.1;
lx 40 140;


% all cuts
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
figure('Name','Spin Wave Dispersion in <1,1,1> directions around lattice point [2,0,0] ');


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
