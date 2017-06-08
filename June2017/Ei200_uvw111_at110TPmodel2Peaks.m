data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [1,1,0];
colors={'r','g','blue','c','m','k'};
BraggName = parWithCorrections.getTextFromVector(bragg);

peP1 = parWithCorrections([-0.325,-0.075,0,0.125,0.425;
    137,15,0,15,155]);
peP1.cut_direction=[1,1,1];
peP1.dE =2;
peP1.dk =0.05;

peP2 = parWithCorrections([-0.3125,-0.0875,0,0.1375,0.3875;
    131,15,0,15,153]);
peP2.cut_direction=[1,1,-1];
peP2.dE =2;
peP2.dk =0.05;

peP3 = parWithCorrections([-0.3375,-0.1125,0,0.1375,0.4125;
    131,15,0,13,151]);
peP3.cut_direction=[1,-1,-1];
peP3.dE =2;
peP3.dk =0.05;

peP4 = parWithCorrections([-0.3635,-0.1375,0,0.1125,0.3375;
    151,15,0,11,131]);
peP4.cut_direction=[1,-1,1];
peP4.dE =2;
peP4.dk =0.1;



repP={peP1,peP2,peP3,peP4};


n_cuts =numel(repP);
fit_par= cell(n_cuts,1);
result = cell(n_cuts,1);
for i=1:numel(repP)
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

figure('Name',['Spin wave intensity along <1,1,1> directions around lattice point: ',BraggName]);
errorbar(result{1}.ampl_vs_e(:,1),result{1}.ampl_vs_e(:,2),result{1}.ampl_vs_e(:,3),colors{1});
hold on

%acolor(colors{1})
%aline('-')

%ds = IXTdataset_1d(result{1}.ampl_vs_e');
%ds.title = 'Spin wave intensity along <1,1,1> directions around lattice point [2,0,0]';
%figH=dd(ds);
figure('Name',['Spin wave intensity along <1,1,1> directions around lattice point: ',BraggName]);
errorbar(result{1}.ampl_vs_e(:,1),result{1}.ampl_vs_e(:,2),result{1}.ampl_vs_e(:,3),'r');
hold on

for i=2:n_cuts
    acolor(colors{i})
    %ds = IXTdataset_1d(result{i}.ampl_vs_e');
    errorbar(result{i}.ampl_vs_e(:,1),result{i}.ampl_vs_e(:,2),result{i}.ampl_vs_e(:,3),colors{i});
    %pd(ds)
end
ly 0 2.5;
lx 20 140;

acolor(colors{1})
aline('-')

%ds = IXTdataset_1d(result{1}.fhhw_vs_e');
%ds.title = 'Spin wave FHHW along <1,1,1> directions around lattice point [2,0,0]';
figure('Name',['Spin wave FHHW along <1,1,1> directions around lattice point:',BraggName]);
errorbar(result{1}.fhhw_vs_e(:,1),result{1}.fhhw_vs_e(:,2),result{1}.fhhw_vs_e(:,3),'r');
hold on
%figH=dd(ds);

for i=2:n_cuts
    errorbar(result{i}.fhhw_vs_e(:,1),result{i}.fhhw_vs_e(:,2),result{i}.fhhw_vs_e(:,3),colors{i});
    %acolor(colors{i})
    %ds = IXTdataset_1d(result{i}.fhhw_vs_e');
    %pd(ds)
end
ly 0 80;
lx 20 140;

figure(cut_plot);
plot(result{1}.fitted_sw(:,1),result{1}.fitted_sw(:,2),['o','r']);
hold on
width_scale = max(result{1}.eval_sw(:,3))/(0.4*(max(result{1}.eval_sw(:,1))-min(result{1}.eval_sw(:,1))));

errorbar(result{1}.eval_sw(:,1),result{1}.eval_sw(:,2),result{1}.eval_sw(:,3)/width_scale,colors{1},'horizontal');
for i=2:n_cuts
    errorbar(result{i}.eval_sw(:,1),result{i}.eval_sw(:,2),result{i}.eval_sw(:,3)/width_scale,colors{i},'horizontal');
end


