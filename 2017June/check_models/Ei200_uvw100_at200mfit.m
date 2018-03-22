function [D,x0,alpha,result] = Ei200_uvw100_at200mfit()
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
cut_direction=[1,0,0];
dE = 5;
dK = 0.1;
colors={'r','g','blue','c','m','k'};

%D_Guess = 1000; % E= D*q^2;
%
% Points on Q-dE plane to make 1D cuts
cut_p =   [-0.0977   20.0000;
    -0.1236   30.0000;
    -0.1458   40.0000;
    -0.1656   50.0000;
    -0.1835   60.0000;
    -0.2001   70.0000;
    -0.2156   80.0000;
    -0.2302   90.0000;
    -0.2440  100.0000;
    -0.2572  110.0000;
    NaN      NaN;
    0.1772   24.0000;
    0.2014   34.0000;
    0.2225   44.0000;
    0.2415   54.0000;
    0.2588   64.0000;
    0.2750   74.0000;
    0.2901   84.0000;
    0.3044   94.0000;
    0.3179  104.0000;
    0.3308  114.0000;
    0.3432  124.0000;
    0.3551  134.0000;
    0.3666  144.0000];

[result1,all_plots]=fit_sw_intensity(data_source,bragg,cut_direction,cut_p,dE,dK);
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

