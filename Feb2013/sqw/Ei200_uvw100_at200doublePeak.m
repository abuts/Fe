data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw';

no_chkpnts='True';
pause on

Imax = 0.2;
repPoints1=[-0.3375,-0.1875,0,0.1875,0.3375;
    123,31,0,27,137];
repPoints2 = [-0.275,-0.075,0,0.175,0.375;
    123,15,0,19,153];

repP={parWithCorrections(repPoints1);parWithCorrections(repPoints2)};
repP{1}.cut_direction=[0,1,0];
repP{1}.dE =2;
repP{1}.dk =0.05;

repP{2}.cut_direction=[1,0,0];
repP{2}.dE =2;
repP{2}.dk =0.1;

colors={'r','g','blue','k','m','u'};
lines ={'ro','gs','bx','kd','yo','rd'};

n_cuts =numel(repP);
fit_par= cell(n_cuts,1);
SWX = cell(n_cuts,1);
SWY   = cell(n_cuts,1);
SWErr = cell(n_cuts,1);
ISW1  = cell(n_cuts,1);
ISW2  = cell(n_cuts,1);
for i=1:numel(repP)
    rp1=repP{i};
    rp1.Esw_threshold=40;
    [fit_par{i},SWX{i},SWY{i},SWErr{i},ISW1{i},ISW2{i}]=fit_2pSpinWave(data_source,[2,0,0],rp1,colors{i},lines{i},no_chkpnts,Imax);
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

best200=struct('par1',fit_par{1},'br1',ISW1{1},'br2',ISW2{1});
save('ei200_uvw100at200best','best200');

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
ly(0,1.1*I1Max);
lx 40 140;


% all cuts
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
figure;

xxi=-0.38:0.01:0.38;
for i=1:n_cuts
    plot(SWX{i},SWY{i},lines{i});
    hold on
    plot(SWErr{i}(1,:),SWErr{i}(2,:),['-',colors{i}]);
    yyi=fitpar(xxi,fit_par{i}.p);
    plot(xxi,yyi,colors{i});
end

D=0;
for i=1:n_cuts
    par = fit_par{i};
    D=D+par.p(3);
end

disp([' D of SQ avrg=',num2str(D)])
