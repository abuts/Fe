function Ei200_uvw110_at110TPmodel2Peaks(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

avrg_par=[0,0,957.9503];
bragg = [1,1,0];
colors={'r','g','blue','c','m','k'};


if nargin == 0
    repPoints1= [-0.2625,-0.0625,0,0.1375,0.3875;
        87,13,0,15,123];
    repPoints2 = [-0.3125,-0.1375,0,0.1375,0.3375;
        109,17,0,15,109];
    repPoints3 = [-0.2625,-0.0875,0,0.1125,0.3875;
        101,11,0,11,119];
    repPoints4 = [-0.3125,-0.0875,0,0.0875,0.3125;
        99,13,0,13,117];
    repPoints5 = [-0.3125,-0.0875,0,0.1375,0.3375;
        99,13,0,15,119];
    repPoints6 = [-0.3125,-0.0875,0,0.0875,0.3375;
        101,15,0,13,117];
    
    rp1=parWithCorrections(repPoints1);
    rp1.fix_x_coordinate=false;
else
    repPoints1= [  -0.2625   -0.0625         0    0.1375    0.3875;
        71.8823    8.0028    3.4393   19.2106  138.8119];
    % 1.1704  -13.4660  970.6693
    repPoints2 = [ -0.3125   -0.1375         0    0.1375    0.3375;
        100.1704   21.3737    1.1704   17.6705  107.1909];
    % 1.5705  -34.1497  980.2241
    repPoints3 = [ -0.2625   -0.0875         0    0.1125    0.3875;
        78.0784   12.0635    1.5705   10.1347  135.5243];
    %    3.4226   10.3652  930.9917
    repPoints4 = [  -0.3125   -0.0875         0    0.0875    0.3125;
        91.1006    9.6435    3.4226   11.4575   97.5789];
    %    1.0e+03 *[    0.0003   -0.0231    1.0188]
    repPoints5=[   -0.3125   -0.0875         0    0.1375    0.3375;
        107.0001   10.1094    0.2880   16.3740  108.5418];
    %3.9129   18.6553  908.4089
    repPoints6 = [ -0.3125   -0.0875         0    0.0875    0.3375;
        86.7949    9.2356    3.9129   12.5002  113.6825];
    
    rp1=parWithCorrections(repPoints1);
    rp1.cut_at_e_points = true;
    rp1.energies = varargin{1};
    %rp1.p = avrg_par;
    rp1.fix_x_coordinate = false;
    
end

no_chkpnts= 'True';% Cuts
% #1
rp1.cut_direction=[1,1,0];
rp1.dE = 5;
rp1.dk = 0.05;
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





