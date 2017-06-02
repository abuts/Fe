function Ei800_uvw110_at1m10TPmod2Peaks(varargin)
% Does not work -- too few points to fit around [1,-1,0]
%
data_source= fullfile(pwd,'sqw','Data','Fe_ei787.sqw');
bragg = [1,1,0];
colors={'r','g','blue','c','m','k'};


if nargin == 0
    repPoints1= [-0.3875,-0.1875,0,0.1875,0.4125;
        160,30,0,30,160];
    repPoints2 = [-0.3375,-0.1875,0,0.2375,0.4625;
        110,30,0,40,190];
    repPoints3 = [-0.3625,-0.1625,0,0.1875,0.4125;
        140,30,0,30,190];
    repPoints4 = [-0.3375,-0.1375,0,0.1875,0.4125;
        140,20,0,30,180];
    repPoints5 = [-0.4375,-0.2125,0,0.1375,0.3375;
        180,30,0,30,140];
    repPoints6 = [-0.3875,-0.1625,0,0.1825,0.3625;
        180,30,0,30,140];
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    %1.0e+03 *[   -0.0117   -0.0038    1.1818]
    repPoints1= [-0.3875   -0.1875         0    0.1875    0.4125;
        167.2300   30.5557  -11.7097   29.1218  187.8074];
    %1.0e+03 *[   -0.0068   -0.0323    1.1292]
    repPoints2 = [-0.3375   -0.1875         0    0.2375    0.4625;
        132.6691   38.9071   -6.8385   49.1955  219.7875];
    % 1.0e+03 *[    0.0003    0.0129    1.0594]
    repPoints3 = [ -0.3625   -0.1625         0    0.1875    0.4125;
        134.8687   26.2039    0.3184   39.9732  185.8838];
    %    3.4226   10.3652  930.9917
    repPoints4 = [  -0.3125   -0.0875         0    0.0875    0.3125;
        91.1006    9.6435    3.4226   11.4575   97.5789];
    %1.0e+03 *[    0.0066    0.0330    1.0269]
    repPoints5=[  -0.4375   -0.2125         0    0.1375    0.3375;
        188.7405   45.9838    6.6260   30.5780  134.7319];
    %1.0e+03 *[   -0.0120    0.0015    1.1848]
    repPoints6 = [ -0.3875   -0.1625         0    0.1825    0.3625;
        165.3115   19.0218  -12.0269   27.7007  144.1918];
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    %rp1.p = avrg_par;
    rp1.fix_x_coordinate = false;
    
end

% #1
rp1.cut_direction=[1,1,0];
rp1.dE=10;
rp1.dk = 0.1;
% #2
rp2 = parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[1,-1,0];
% #3
rp3 = parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[1,0,1];

% #4
rp4 = parWithCorrections(rp1);
rp4.ref_par_X = repPoints4;
rp4.cut_direction=[1,0,-1];

% #5
rp5 = parWithCorrections(rp1);
rp5.ref_par_X = repPoints5;
rp5.cut_direction=[0,1,1];

% #6
rp6 = parWithCorrections(rp1);
rp6.ref_par_X = repPoints6;
rp6.cut_direction=[0,1,-1];

repP={rp1,rp2,rp3,rp4,rp5,rp6};

BraggName = parWithCorrections.getTextFromVector(bragg);
n_cuts =numel(repP);
result = cell(n_cuts,1);
for i=1:n_cuts
    rp1=repP{i};
    cut_p = rp1.get_cut2peak_points();
    
    [result1,all_plots] = fit_swTP_model(data_source,bragg,rp1.cut_direction,cut_p,rp1.dE,rp1.dk);
    for j=1:numel(all_plots)
        if i==1 && j==1
            cut_plot = all_plots(j);
            
            keep_figure(cut_plot);
            
            
            continue;
        end
        close(all_plots(j));
    end
    result{i} = result1;
    
    
    
end
I_max = -1.e+64;
FHH_max = -1.e+64;
for i=1:n_cuts
    I_max = max([result{i}.ampl_vs_e(2,:),I_max]);
    FHH_max = max([result{i}.fhhw_vs_e(2,:),FHH_max]);
    % prepare to swith to IXTdataset_1d
    %result{i}.ampl_vs_e(nans,1) = 0;
    %result{i}.fhhw_vs_e(nans,1)  = 0;
end
disp(['Max Intensity: ', num2str(I_max),' Max FHHW: ',num2str(FHH_max)]);

figure('Name',['Spin wave intensity along <1,0,0> directions around lattice point ',BraggName]);
errorbar(result{1}.ampl_vs_e(:,1),result{1}.ampl_vs_e(:,2),result{1}.ampl_vs_e(:,3),colors{1});
hold on

for i=2:n_cuts
    acolor(colors{i})
    %ds = IXTdataset_1d(result{i}.ampl_vs_e');
    errorbar(result{i}.ampl_vs_e(:,1),result{i}.ampl_vs_e(:,2),result{i}.ampl_vs_e(:,3),colors{i});
    %pd(ds)
end
ly 0 2.;
lx 20 180;

acolor(colors{1})
aline('-')

%ds = IXTdataset_1d(result{1}.fhhw_vs_e');
%ds.title = 'Spin wave FHHW along <1,1,1> directions around lattice point [2,0,0]';
figure('Name',['Spin wave FHHW along <1,0,0> directions around lattice point ',BraggName]);
errorbar(result{1}.fhhw_vs_e(:,1),result{1}.fhhw_vs_e(:,2),result{1}.fhhw_vs_e(:,3),colors{1});
hold on
%figH=dd(ds);

for i=2:n_cuts
    errorbar(result{i}.fhhw_vs_e(:,1),result{i}.fhhw_vs_e(:,2),result{i}.fhhw_vs_e(:,3),colors{i});
    %acolor(colors{i})
    %ds = IXTdataset_1d(result{i}.fhhw_vs_e');
    %pd(ds)
end
ly 0 0.5;
lx 20 180;


%figure('Name',['Tobyfitted spin wave dispersion at: ', BraggName]);
figure(cut_plot);
plot(result{1}.fitted_sw(:,1),result{1}.fitted_sw(:,2),['o','r']);
hold on
width_scale = max(result{1}.eval_sw(:,3))/(0.4*(max(result{1}.eval_sw(:,1))-min(result{1}.eval_sw(:,1))));

errorbar(result{1}.eval_sw(:,1),result{1}.eval_sw(:,2),result{1}.eval_sw(:,3)/width_scale,colors{1},'horizontal');
for i=2:3
    errorbar(result{i}.eval_sw(:,1),result{i}.eval_sw(:,2),result{i}.eval_sw(:,3)/width_scale,colors{i},'horizontal');
end




%bestE400k110=struct('par1',fit_par{1},'br1',ISW1{1},'br2',ISW2{1});
%save('ei400_uvw100at110best','bestE400k110');


