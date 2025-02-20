function do_fits(data_source,bragg,dir_id,repP)
% run selection of sw fits and display the result
%
% Input:
% data_source -- full name of the sqw file to make cuts from
% bragg       -- id of the bragg peak to explore  (3-component vector,
%                containing hkl coordinates of the peak, e.g. [1,1,0] or [2,0,0])
% dir_id      -- the cut plain index
% repP        -- list of the parWithCorrections classes containing
%                information about cut parameters.
%

BraggName = parWithCorrections.getTextFromVector(bragg);
colors={'r','g','blue','c','m','k'};

n_cuts =numel(repP);
result = cell(n_cuts,1);
cut_plot = [];
%
E_min = 1.e+64;
E_max = -E_min;
for i=1:n_cuts
    rp1=repP{i};
    %en_range = rp1.getMinErange();
    en_range = rp1.getMaxErange();
    q_range =  rp1.getQvsE(en_range,1);
    if ~isreal(q_range)
        error('DO_FIRS:invalid_arguments',...
            ' initial fit points are incorrect as quadratic equation has complex roots');
    end
    cut_p  =   [q_range,en_range];
    %cut_p = rp1.get_cut2peak_points();
    %E_min = min(E_min,rp1.emin(0));
    %E_max = max(E_max,rp1.emax(0));
    
    [result1,all_plots] = select_swTP_model(data_source,bragg,rp1.cut_direction,cut_p,rp1.dE,rp1.dk);
    for j=1:numel(all_plots)
        if isempty(cut_plot)
            cut_plot = all_plots(j);
            keep_figure(cut_plot);
            continue;
        end
        if ishandle(all_plots(j))
            close(all_plots(j));
        end
    end
    result{i} = result1;
    %E_min = min(E_min,min(result1.esw_valid));
    %E_max = max(E_max,max(result1.esw_valid));
end
% I_max = -1.e+64;
% FHH_max = -1.e+64;
% for i=1:n_cuts
%     I_max = max([result{i}.ampl_vs_e(2,:),I_max]);
%     FHH_max = max([result{i}.fhhw_vs_e(2,:),FHH_max]);
%     % prepare to swith to IXTdataset_1d
%     %result{i}.ampl_vs_e(nans,1) = 0;
%     %result{i}.fhhw_vs_e(nans,1)  = 0;
% end
% disp(['Max Intensity: ', num2str(I_max),' Max FHHW: ',num2str(FHH_max)]);
%
% figure('Name',['Spin wave intensity along ',dir_id,' dir. around ',BraggName]);
% errorbar(result{1}.ampl_vs_e(:,1),result{1}.ampl_vs_e(:,2),result{1}.ampl_vs_e(:,3),colors{1});
% hold on
% for i=2:n_cuts
%     acolor(colors{i})
%     %ds = IXTdataset_1d(result{i}.ampl_vs_e');
%     errorbar(result{i}.ampl_vs_e(:,1),result{i}.ampl_vs_e(:,2),result{i}.ampl_vs_e(:,3),colors{i});
%     %pd(ds)
% end
% lx(E_min-5,E_max+10);
% ly(0, 2.5);
%
% acolor(colors{1})
% aline('-')
%
% %ds = IXTdataset_1d(result{1}.fhhw_vs_e');
% %ds.title = 'Spin wave FHHW along <1,1,1> directions around lattice point [2,0,0]';
% figure('Name',['Spin wave width along ',dir_id,' dir. around: ',BraggName]);
% errorbar(result{1}.fhhw_vs_e(:,1),result{1}.fhhw_vs_e(:,2),result{1}.fhhw_vs_e(:,3),colors{1});
% hold on
% %figH=dd(ds);
%
% for i=2:n_cuts
%     errorbar(result{i}.fhhw_vs_e(:,1),result{i}.fhhw_vs_e(:,2),result{i}.fhhw_vs_e(:,3),colors{i});
%     %acolor(colors{i})
%     %ds = IXTdataset_1d(result{i}.fhhw_vs_e');
%     %pd(ds)
% end
% lx(E_min-5,E_max+10);
% ly(0, 80);
%
%
% %figure('Name',['Tobyfitted spin wave dispersion at: ', BraggName]);
% % figure(cut_plot);
% % plot(result{1}.fitted_sw(:,1),result{1}.fitted_sw(:,2),['o','r']);
% % hold on
% % width_scale = max(result{1}.eval_sw(:,3))/(0.4*(max(result{1}.eval_sw(:,1))-min(result{1}.eval_sw(:,1))));
% %
% % errorbar(result{1}.eval_sw(:,1),result{1}.eval_sw(:,2),result{1}.eval_sw(:,3)/width_scale,colors{1},'horizontal');
% % for i=2:n_cuts
% %     errorbar(result{i}.eval_sw(:,1),result{i}.eval_sw(:,2),result{i}.eval_sw(:,3)/width_scale,colors{i},'horizontal');
% % end
% % lx(-0.8, 0.8)
% % ly(0, E_max+50);
