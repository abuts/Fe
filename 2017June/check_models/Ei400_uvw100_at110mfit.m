function Ei400_uvw100_at110mfit(varargin)

data_source= fullfile(pwd,'sqw','Data','Fe_ei401.sqw');
bragg = [1,1,0];
colors={'r','g','blue','c','m','k'};
if nargin == 0
    repPoints1= [-0.3375,-0.175,0,0.175,0.375;
        135,30,0,30,190];
    
    repPoints2 = [-0.325,-0.125,0,0.175,0.425;
        130,30,0,30,190];
    repPoints3 = [-0.375,-0.125,0,0.125,0.375;
        170,20,0,20,170];

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
    rp1.fix_x_coordinate = false;
end
% Cuts
% #1
rp1.cut_direction=[0,1,0];
rp1.dE = 5;
rp1.dk = 0.1;
% #2
rp2 = parWithCorrections(rp1);
rp2.ref_par_X = repPoints2;
rp2.cut_direction=[1,0,0];
% #3
rp3 = parWithCorrections(rp1);
rp3.ref_par_X = repPoints3;
rp3.cut_direction=[0,0,1];

repP={rp3,rp2,rp1};
%run_cuts(data_source,no_chkpnts,repP,[1,1,0],Imax,n_energy_points,'Ei400','<1,0,0>')


BraggName = parWithCorrections.getTextFromVector(bragg);

n_cuts =numel(repP);
result = cell(n_cuts,1);
for i=1:n_cuts 
    rp1=repP{i};
    cut_p = rp1.get_cut_points();

    %[fit_par{i},SWX{i},SWY{i},SWErr{i},ISW1{i},ISW2{i}]=fit_1SpinWave(data_source,bragg,rp1,colors{i},lines{i},use_chkpnts,Imax);    
    [result1,all_plots]=fit_sw_intensity(data_source,bragg,rp1.cut_direction,cut_p,rp1.dE,rp1.dk);
    for j=1:numel(all_plots)
        if i==1 && j==1
            cut_plot = all_plots(j);
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
hold on
plot(result{1}.fitted_sw(:,1),result{1}.fitted_sw(:,2),['o','k']);
errorbar(result{1}.eval_sw(:,1),result{1}.eval_sw(:,2),result{1}.eval_sw(:,3),colors{1});
for i=2:n_cuts
    errorbar(result{i}.eval_sw(:,1),result{i}.eval_sw(:,2),result{i}.eval_sw(:,3),colors{i});            
end




%bestE400k110=struct('par1',fit_par{1},'br1',ISW1{1},'br2',ISW2{1});
%save('ei400_uvw100at110best','bestE400k110');

