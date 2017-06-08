function [D,x0,alpha,result] = Ei200_uvw100_at200mfit2Peaks()
% simplified verification script, which allows one to check
% how do sqw cut works

%-------------------------------------------------
% Parameters :
%
data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [2,0,0];  % selected bragg
%
% Cut properties:
%
colors={'r','g','blue','c','m','k'};

peP1 = parWithCorrections([-0.2572,-0.0977,0,0.1772,0.3179;
    110,20,0,24,104]);
peP1.cut_direction=[1,0,0];
peP1.dE =2.5;
peP1.dk =0.05;

cut_p = peP1.get_cut2peak_points();
[result1,all_plots]=fit_sw2peak_intensity(data_source,bragg,peP1.cut_direction,cut_p,peP1.dE,peP1.dk);
for i=1:numel(all_plots)
    if i==1
        cut_plot = all_plots(i);
        keep_figure(cut_plot);
        continue
    end
    
    close(all_plots(i));
end
sw_param = result1.sw_par;% (result1.sw_par+result2.sw_par+result3.sw_par)/3;
D     = sw_param(3);
alpha = sw_param(2);
x0    = sw_param(1);
result = result1;
result.sw_par = sw_param;

caption =@(vector)['[' num2str(vector(1)) ',' num2str(vector(2)) ',' num2str(vector(3)) ']'];

figure('Name',['Tobyfitted SW intensity along dE; peak: ',caption(bragg)]);
li1=errorbar(result1.ampl_vs_e(:,1),result1.ampl_vs_e(:,2),result1.ampl_vs_e(:,3),'r');
hold on
%li2=errorbar(result2.ampl_vs_e(:,1),result2.ampl_vs_e(:,2),result2.ampl_vs_e(:,3),'g');
%li3=errorbar(result3.ampl_vs_e(:,1),result3.ampl_vs_e(:,2),result3.ampl_vs_e(:,3),'b');
ly 0 1
plots =li1;% [li1,li2,li3];

legend(plots,['direction: ',caption([1,0,0])],...
    ['direction: ',caption([0,1,0])],...
    ['direction: ',caption([0,0,1])]);

figure('Name',['Tobyfitted FHHW along dE; peak: ',caption(bragg)]);
lf1=errorbar(result1.fhhw_vs_e(:,1),result1.fhhw_vs_e(:,2),result1.fhhw_vs_e(:,3),'r');
hold on
%lf2=errorbar(result2.fhhw_vs_e(:,1),result2.fhhw_vs_e(:,2),result2.fhhw_vs_e(:,3),'g');
%lf3=errorbar(result3.fhhw_vs_e(:,1),result3.fhhw_vs_e(:,2),result3.fhhw_vs_e(:,3),'b');

plots = lf1; %[lf1,lf2,lf3];
ly 0 1
legend(plots,['direction: ',caption([1,0,0])],...
    ['direction: ',caption([0,1,0])],...
    ['direction: ',caption([0,0,1])]);


figure(cut_plot);
hold on
plot(result{1}.fitted_sw(:,1),result{1}.fitted_sw(:,2),['-','r']);
errorbar(result{1}.eval_sw(:,1),result{1}.eval_sw(:,2),result{1}.eval_sw(:,3),colors{1},'horizontal');
for i=2:numel(result)
    errorbar(result{i}.eval_sw(:,1),result{i}.eval_sw(:,2),result{i}.eval_sw(:,3),colors{i},'horizontal');
end

