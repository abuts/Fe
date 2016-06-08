function Ei400_uvw100_at110auto(varargin)

data_source= fullfile(pwd,'Fe_ei787.sqw');
avrg_par=[0,0,1139.482];

no_chkpnts='True';
pause on

Imax = 0.2;
if nargin == 0
    repPoints1= [-0.325,-0.075,0,0.125,0.425;
                         137,15,0,15,155];    
    repPoints2 = [-0.3125,-0.0875,0,0.1375,0.3875;
                         131,15,0,15,153];
    repPoints3 = [-0.3375,-0.1125,0,0.1375,0.4125;
                         131,15,0,13,151];
    repPoints4 = [-0.4125,-0.1375,0,0.0875,0.3375;
                         153,15,0,11,131];



    rp1 = parWithCorrections(repPoints1);
    rp1.fix_x_coordinate = false;
else
    repPoints1=  [  -0.3375   -0.1625         0    0.1875    0.3875;
        132.3383   31.2726    0.7914   41.4428  174.3464];
    repPoints2=[-0.3375   -0.1625         0    0.1875    0.4375;
        130.3234   31.8632    2.2336   41.9916  218.2458];
    
    repPoints3=[-0.3875   -0.1375         0    0.1625    0.3875;
        187.6851   29.8303    3.5519   27.8886  160.6537];
    
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    % ignore reference points and set spin wave parameters directly
    %rp1.p = avrg_par;
    % check it, true sets cut position on the spin wave exactly
    rp1.fix_x_coordinate = true;

end
% Cuts
% #1
rp1.cut_direction=[1,1,1];
rp1.dE = 10;
rp1.dk = 0.1;
% #2
rp2 = parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[1,1,-1];
% #3
rp3 = parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[1,-1,-1];

rp4 = parWithCorrections(rp1);
rp4.ref_par_X = repPoints4;
rp4.cut_direction=[-1,1,-1];


repP={rp1,rp2,rp3,rp4};
n_energy_points=10;
if(nargin>0)
    n_energy_points = numel(varargin{1});
end
run_cuts(data_source,no_chkpnts,repP,[2,0,0],Imax,n_energy_points)

% 
% repP={peP2,peP3,peP4,peP5,peP6,peP1};
% 
% colors={'r','g','blue','c','m','k'};
% lines ={'ro','gs','bx','cd','mo','kd'};
% 
% n_cuts =numel(repP);
% fit_par= cell(n_cuts,1);
% SWX = cell(n_cuts,1);
% SWY   = cell(n_cuts,1);
% SWErr = cell(n_cuts,1);
% ISW1  = cell(n_cuts,1);
% ISW2  = cell(n_cuts,1);
% for i=1:numel(repP)
%     rp1=repP{i}; 
%     [fit_par{i},SWX{i},SWY{i},SWErr{i},ISW1{i},ISW2{i}]=fit_1SpinWave(data_source,[1,1,0],rp1,colors{i},lines{i},no_chkpnts,Imax);
% end
% 
% I_max = -1.e+64;
% for i=1:n_cuts
%     I_max = max([ISW1{i}.signal;ISW2{i}.signal;I_max]);
% end
% disp(['Max Intensity: ', num2str(I_max)]);
% 
% for i=1:n_cuts
%     ISW1{i} = ISW1{i}/I_max;
%     ISW2{i} = ISW2{i}/I_max;
% end
% 
% 
% acolor(colors{1})
% aline('-')
% figH=dd(ISW1{1});
% set(figH,'Name','Spin wave intensity along <1,0,0> directions around lattice point [2,0,0]')
% pd(ISW2{1})
% 
% for i=2:n_cuts
%     acolor(colors{i})
%     pd(ISW1{i})
%     pd(ISW2{i})
% end
% ly 0 1.1;
% lx 40 140;
% 
% 
% % all cuts
% fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
% figure('Name','Spin Wave Dispersion in <1,1,1> directions around lattice point [2,0,0] ');
% 
% 
% xxi=-0.38:0.01:0.38;
% for i=1:n_cuts
%     plot(SWX{i},SWY{i},lines{i});
%     hold on
%     plot(SWErr{i}(1,:),SWErr{i}(2,:),['-',colors{i}]);
%     yyi=fitpar(xxi,fit_par{i}.p);
%     plot(xxi,yyi,colors{i});
% end
% lx -0.5 0.5
% 
% D=0;
% for i=1:n_cuts
%     par = fit_par{i};
%     D=D+par.p(3);
% end
% 
% disp([' D of SQ avrg=',num2str(D)])
