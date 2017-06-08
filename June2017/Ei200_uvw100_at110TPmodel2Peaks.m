function [D,x0,alpha,result] = Ei200_uvw100_at110TPmodel2Peaks()
% simplified verification script, which allows one to check
% how do sqw cut works

%-------------------------------------------------
% Parameters :
%
data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [1,1,0];  % selected bragg
colors={'r','g','blue','c','m','k'};
%
% Cut properties:
%
cut_direction=[1,0,0];
dE = 2.5;
dK = 0.05;
%D_Guess = 1000; % E= D*q^2;
%
% Points on Q-dE plane to make 1D cuts
cut_p =   [  0.1638   21.5000;
    0.1796   26.5000;
    0.1938   31.5000;
    0.2070   36.5000;
    0.2193   41.5000;
    0.2308   46.5000;
    0.2417   51.5000;
    0.2520   56.5000;
    0.2620   61.5000;
    0.2715   66.5000;
    0.2806   71.5000;
    0.2895   76.5000;
    0.2980   81.5000;
    0.3063   86.5000;
    0.3144   91.5000];

[result1,all_plots]=fit_swTP_model(data_source,bragg,cut_direction,cut_p,dE,dK);
%[result1,all_plots]=fit_sw_intensity(data_source,bragg,cut_direction,cut_p,dE,dK);
for i=1:numel(all_plots)
    if i==1
        cut_plot = all_plots(i);
        keep_figure(cut_plot);
        continue;
    end
    close(all_plots(i));
end
cut_direction = [0,1,0];
% Points on Q-dE plane to make 1D cuts
cut_p =   [ 
    0.1416   21.5000;
    0.1578   26.5000;
    0.1723   31.5000;
    0.1857   36.5000;
    0.1982   41.5000;
    0.2099   46.5000;
    0.2209   51.5000;
    0.2315   56.5000;
    0.2415   61.5000;
    0.2511   66.5000;
    0.2604   71.5000;
    0.2693   76.5000;
    0.2780   81.5000;
    0.2863   86.5000;
    0.2945   91.5000];
[result2,all_plots1]=fit_swTP_model(data_source,bragg,cut_direction,cut_p,dE,dK);
%[result2,all_plots1]=fit_sw_intensity(data_source,bragg,cut_direction,cut_p,dE,dK);
for i=1:numel(all_plots1)
    
    close(all_plots1(i));
end

cut_direction = [0,0,1];
% Points on Q-dE plane to make 1D cuts
cut_p =   [  0.1229   21.5000;
    0.1382   26.5000;
    0.1521   31.5000;
    0.1648   36.5000;
    0.1767   41.5000;
    0.1879   46.5000;
    0.1984   51.5000;
    0.2084   56.5000;
    0.2180   61.5000;
    0.2272   66.5000;
    0.2361   71.5000;
    0.2446   76.5000;
    0.2529   81.5000];
[result3,all_plots2]=fit_swTP_model(data_source,bragg,cut_direction,cut_p,dE,dK);
%[result3,all_plots2]=fit_sw_intensity(data_source,bragg,cut_direction,cut_p,dE,dK);
for i=1:numel(all_plots2)
    close(all_plots2(i));
end
%
sw_param = (result1.sw_par+result2.sw_par+result3.sw_par)/3;
D     = sw_param(3);
alpha = sw_param(2);
x0    = sw_param(1);
result = result1;
result.sw_par = sw_param;

caption =@(vector)['[' num2str(vector(1)) ',' num2str(vector(2)) ',' num2str(vector(3)) ']'];

figure('Name',['Tobyfitted SW intensity along dE; peak: ',caption(bragg)]);
li1=errorbar(result1.ampl_vs_e(:,1),result1.ampl_vs_e(:,2),result1.ampl_vs_e(:,3),'r');
hold on
li2=errorbar(result2.ampl_vs_e(:,1),result2.ampl_vs_e(:,2),result2.ampl_vs_e(:,3),'g');
li3=errorbar(result3.ampl_vs_e(:,1),result3.ampl_vs_e(:,2),result3.ampl_vs_e(:,3),'b');
ly 0 2
plots = [li1,li2,li3];

legend(plots,['direction: ',caption([1,0,0])],...
    ['direction: ',caption([0,1,0])],...
    ['direction: ',caption([0,0,1])]);

figure('Name',['Tobyfitted FHHW along dE; peak: ',caption(bragg)]);
lf1=errorbar(result1.fhhw_vs_e(:,1),result1.fhhw_vs_e(:,2),result1.fhhw_vs_e(:,3),'r');
hold on
lf2=errorbar(result2.fhhw_vs_e(:,1),result2.fhhw_vs_e(:,2),result2.fhhw_vs_e(:,3),'g');
lf3=errorbar(result3.fhhw_vs_e(:,1),result3.fhhw_vs_e(:,2),result3.fhhw_vs_e(:,3),'b');

plots = [lf1,lf2,lf3];
ly 0 80
legend(plots,['direction: ',caption([1,0,0])],...
    ['direction: ',caption([0,1,0])],...
    ['direction: ',caption([0,0,1])]);

%figure('Name',['Tobyfitted spin wave dispersion at: ', BraggName]);
result = {result1,result2,result3};
figure(cut_plot);
plot(result{1}.fitted_sw(:,1),result{1}.fitted_sw(:,2),['o','r']);
hold on
width_scale = max(result{1}.eval_sw(:,3))/(0.4*(max(result{1}.eval_sw(:,1))-min(result{1}.eval_sw(:,1))));

errorbar(result{1}.eval_sw(:,1),result{1}.eval_sw(:,2),result{1}.eval_sw(:,3)/width_scale,colors{1},'horizontal');
for i=2:3
    errorbar(result{i}.eval_sw(:,1),result{i}.eval_sw(:,2),result{i}.eval_sw(:,3)/width_scale,colors{i},'horizontal');
end



