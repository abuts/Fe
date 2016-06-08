function [ D ] = run_cuts(data_source,use_chkpnts,repP,bragg,Imax,n_energy_points,EiName,CutName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
colors={'r','g','blue','c','m','k'};
lines ={'ro','gs','bx','cd','mo','kd'};

BraggName = parWithCorrections.getTextFromVector(bragg);

n_cuts =numel(repP);
fit_par= cell(n_cuts,1);
SWX = cell(n_cuts,1);
SWY   = cell(n_cuts,1);
SWErr = cell(n_cuts,1);
ISW1  = cell(n_cuts,1);
ISW2  = cell(n_cuts,1);
for i=1:numel(repP)
    rp1=repP{i};
    
    [fit_par{i},SWX{i},SWY{i},SWErr{i},ISW1{i},ISW2{i}]=fit_1SpinWave(data_source,bragg,rp1,colors{i},lines{i},use_chkpnts,Imax);
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


%bestE400k110=struct('par1',fit_par{1},'br1',ISW1{1},'br2',ISW2{1});
%save('ei400_uvw100at110best','bestE400k110');

D=0;
for i=1:n_cuts
    par = fit_par{i};
    D=D+par.p(3);
end
D=D/n_cuts;

disp([' D of SQ avrg=',num2str(D)]);
if nargin > 0 && n_energy_points < 3
    return;
end

acolor(colors{1})
aline('-')
figH=dd(ISW1{1});
fig_name = sprintf('%s; Spin wave intensity along %s  directions around lattice point: %s',EiName,CutName,BraggName);
set(figH,'Name',fig_name)
pd(ISW2{1})
str_2save = struct();
for i=2:n_cuts
    acolor(colors{i})
    pd(ISW1{i})
    pd(ISW2{i})
end

for i=1:n_cuts
    name = sprintf('%d',i);
    str_2save.(['cut_par_',name])=repP{i};
    str_2save.(['ISW1_',name])=ISW1{i};
    str_2save.(['ISW2_',name])=ISW2{i};
end

%ly(0.4*I_max,I_max*1.2);
ly(0,I_max*1.2);
lx 40 190

% all cuts
fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
fig_name = sprintf('dispersion: %s %s; at %s',EiName,CutName,BraggName);
figure('Name',fig_name);

xxi=-0.38:0.01:0.38;
for i=1:n_cuts
    plot(SWX{i},SWY{i},lines{i});
    hold on
    plot(SWErr{i}(1,:),SWErr{i}(2,:),['-',colors{i}]);
    yyi=fitpar(xxi,fit_par{i}.p);
    plot(xxi,yyi,colors{i});
    
    name = sprintf('%d',i);
    str_2save.(['SWX_',name])=SWX{i};
    str_2save.(['SWY_',name])=SWY{i};
    str_2save.(['fit_par_',name])=fit_par{i};  
end
lx -0.5 0.5

disp([' D of SQ avrg=',num2str(D/(2.18093^2))])
% save results to plotting later
file_name = sprintf('%s_%s_%s.mat',EiName,CutName,BraggName);
file_name = regexprep(file_name,'[\<\>]','!');
file_name = regexprep(file_name,'\,','d');
file_name = regexprep(file_name,'-','m');

save(file_name,'str_2save');


end

