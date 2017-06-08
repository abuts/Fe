function [D,x0,alpha,result] = Ei200_uvw100_at110mfit()
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
cut_p =   [-0.1095   21.5000;
    -0.1253   26.5000;
    -0.1396   31.5000;
    -0.1527   36.5000;
    -0.1650   41.5000;
    -0.1765   46.5000;
    -0.1874   51.5000;
    -0.1978   56.5000;
    -0.2077   61.5000;
    -0.2172   66.5000;
    -0.2264   71.5000;
    -0.2352   76.5000;
    -0.2438   81.5000;
    -0.2520   86.5000;
    -0.2601   91.5000;
    NaN      NaN;
    0.1638   21.5000;
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
    0.3144   91.5000;
    0.3222   96.5000;
    0.3298  101.5000;
    0.3373  106.5000;
    0.3445  111.5000;
    0.3516  116.5000];

[result1,all_plots]=fit_sw_intensity(data_source,bragg,cut_direction,cut_p,dE,dK);
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
cut_p =   [  -0.1132   17.5000;
    -0.1310   22.5000;
    -0.1468   27.5000;
    -0.1611   32.5000;
    -0.1743   37.5000;
    -0.1866   42.5000;
    -0.1982   47.5000;
    -0.2091   52.5000;
    -0.2195   57.5000;
    -0.2295   62.5000;
    -0.2390   67.5000;
    -0.2482   72.5000;
    -0.2571   77.5000;
    -0.2657   82.5000;
    -0.2740   87.5000;
    -0.2821   92.5000;
    NaN      NaN;
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
    0.2945   91.5000;
    0.3024   96.5000;
    0.3101  101.5000;
    0.3176  106.5000;
    0.3249  111.5000;
    0.3321  116.5000];

[result2,all_plots1]=fit_sw_intensity(data_source,bragg,cut_direction,cut_p,dE,dK);
for i=1:numel(all_plots1)

    close(all_plots1(i));
end

cut_direction = [0,0,1];
% Points on Q-dE plane to make 1D cuts
cut_p =   [ -0.1445   23.5000;
    -0.1591   28.5000;
    -0.1725   33.5000;
    -0.1849   38.5000;
    -0.1964   43.5000;
    -0.2073   48.5000;
    -0.2177   53.5000;
    -0.2275   58.5000;
    -0.2369   63.5000;
    -0.2460   68.5000;
    -0.2547   73.5000;
    -0.2631   78.5000;
    -0.2713   83.5000;
    -0.2792   88.5000;
    -0.2869   93.5000;
    -0.2944   98.5000;
    -0.3017  103.5000;
    NaN      NaN;
    0.1229   21.5000;
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

[result3,all_plots2]=fit_sw_intensity(data_source,bragg,cut_direction,cut_p,dE,dK);
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
ly 0 1
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
ly 0 1
legend(plots,['direction: ',caption([1,0,0])],...
    ['direction: ',caption([0,1,0])],...
    ['direction: ',caption([0,0,1])]);

%figure('Name',['Tobyfitted spin wave dispersion at: ', BraggName]);
figure(cut_plot);
result = {result1,result2,result3};
plot(result{1}.fitted_sw(:,1),result{1}.fitted_sw(:,2),['-','g']);
hold on
errorbar(result{1}.eval_sw(:,1),result{1}.eval_sw(:,2),result{1}.eval_sw(:,3),colors{1});
for i=2:3
    errorbar(result{i}.eval_sw(:,1),result{i}.eval_sw(:,2),result{i}.eval_sw(:,3),colors{i});            
end
