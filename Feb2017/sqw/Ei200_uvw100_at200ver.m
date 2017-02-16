function [D,x0,alpha,e_sw,Icr,dIcr] = Ei200_uvw100_at200ver()
% simplified verification script, which allows one to check
% how do sqw cut works

%-------------------------------------------------
% Parameters :
%
data_source= fullfile(pwd,'Data','sqw','Fe_ei200.sqw');

bragg = [2,0,0];  % selected bragg
%
% Cut properties:
%
cut_direction=[1,0,0];
dE = 5;
dK = 0.1;
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

[D,x0,alpha,e_sw,Icr,dIcr,all_plots]=calc_sw_intencity(data_source,bragg,cut_direction,cut_p,dE,dK);
for i=1:3
    close(all_plots(i));
end
