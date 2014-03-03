function Ei200_uvw100_at200auto(varargin)

data_source= fullfile(pwd,'Fe_ei200.sqw');
avrg_par=[0,0,949.35];
no_chkpnts= 'True';
Imax = 1;
if nargin == 0
    repPoints1=[-0.3375,-0.1875,0,0.1875,0.3375;
        123,31,0,27,137];
    
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
    repPoints2 = [-0.275,-0.075,0,0.175,0.375;
        123,15,0,19,153];
    rp1.dE = 2.5;
    rp1.dk = 0.1;
    
    
    rp2=parWithCorrections(rp1);
    rp2.ref_par_X = repPoints2;    
else
    repPoints1= [ -0.2875 ,  -0.0875 ,        0  ,  0.1375 ,   0.3375;
        81.7839 ,  13.0408  ,  6.1338  , 23.7725,  111.5941];
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    rp1.p = avrg_par;
end

rp1.cut_direction=[0,1,0];
rp1.cut_direction=[1,0,0];


repP={rp1,rp2};


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
    [fit_par{i},SWX{i},SWY{i},SWErr{i},ISW1{i},ISW2{i}]=fit_1SpinWave(data_source,[2,0,0],rp1,colors{i},lines{i},no_chkpnts,Imax);
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
if nargin > 0 && numel(varargin{1}) < 3
    D=0;
    for i=1:n_cuts
        par = fit_par{i};
        D=D+par.p(3);
    end
    disp([' D of SQ avrg=',num2str(D)]);
    return;
end

%best200=struct('par1',fit_par{1},'br1',ISW1{1},'br2',ISW2{1});
%save('ei200_uvw100at200best','best200');

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
disp([' D of SQ avrg=',num2str(D)]);

disp([' D of SQ avrg=',num2str(D)])
