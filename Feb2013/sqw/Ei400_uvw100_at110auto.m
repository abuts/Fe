data_source= 'd:\Data\Fe\Feb2013\sqw\Fe_ei401.sqw';

no_chkpnts= 'True';
Imax = 1; % fitting considered wrong if intensity deviates from average by this range
repPoints1= [-0.3375,-0.1625,0,0.1875,0.3875;
    135,31,0,23,187];
repPoints2 = [-0.3375,-0.1625,0,0.1875,0.4375;
    133,31,0,25,189];
repPoints3 = [-0.3875,-0.1375,0,0.1625,0.3875;
    159,25,0,25,163];
repP={parWithCorrections(repPoints1);parWithCorrections(repPoints2);parWithCorrections(repPoints3)};
repP{1}.cut_direction=[0,1,0];

repP{2}.cut_direction=[1,0,0];
repP{2}.dE =4;
repP{2}.dk =0.05;

repP{3}.cut_direction=[0,0,1];
repP{3}.dE =4;
repP{3}.dk =0.05;

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
    rp1.dE =4;
    rp1.dk =0.1;
    
    [fit_par{i},SWX{i},SWY{i},SWErr{i},ISW1{i},ISW2{i}]=fit_1SpinWave(data_source,[1,1,0],rp1,colors{i},lines{i},no_chkpnts,Imax);
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


bestE400k110=struct('par1',fit_par{1},'br1',ISW1{1},'br2',ISW2{1});
save('ei400_uvw100at110best','bestE400k110');


acolor(colors{1})
aline('-')
figH=dd(ISW1{1});
set(figH,'Name','Ei400; Spin wave intensity along <1,0,0> directions around lattice point [1,1,0]')
pd(ISW2{1})
for i=2:n_cuts
    acolor(colors{i})
    pd(ISW1{i})
    pd(ISW2{i})
end
ly(0.4*I_max,I_max*1.2);
lx 20 190


% all cuts
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
figure('Name','dispersion: Ei400, <1,0,0>; at 110');

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

disp([' D of SQ avrg=',num2str(D/n_cuts)])

